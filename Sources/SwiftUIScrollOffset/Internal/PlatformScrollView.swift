/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Combine

#if canImport(UIKit)

import UIKit
internal typealias PlatformScrollView = UIScrollView

internal extension UIScrollView {
    var displayScale: CGFloat {
        traitCollection.displayScale
    }
    
    var isRightToLeft: Bool {
        effectiveUserInterfaceLayoutDirection == .rightToLeft
    }
    
    var scrollContentOffset: CGPoint {
        contentOffset
    }
    
    var scrollContentSize: CGSize {
        contentSize
    }
    
    func subscribeToContentOffset(_ sink: @escaping () -> Void) -> AnyCancellable {
        self
            .publisher(for: \.contentSize, options: [.initial, .new])
            .didChange()
            .sink(receiveValue: sink)
    }
    
    func subscribeToContentSize(_ sink: @escaping () -> Void) -> AnyCancellable? {
        self
            .publisher(for: \.contentSize, options: [.initial, .new])
            .didChange()
            .sink { self.updateOffset(for: id) }
    }
}

#elseif canImport(AppKit)

import AppKit
internal typealias PlatformScrollView = NSScrollView

internal extension NSScrollView {
    var adjustedContentInset: NSEdgeInsets {
        contentInsets
    }
    
    var displayScale: CGFloat {
        window?.backingScaleFactor ?? 1
    }
    
    var isRightToLeft: Bool {
        userInterfaceLayoutDirection == .rightToLeft
    }
    
    var scrollContentOffset: CGPoint {
        documentVisibleRect.origin
    }
    
    var scrollContentSize: CGSize {
        documentView?.frame.size ?? .zero
    }
    
    func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
        let oldOffset = scrollContentOffset
        
        NSAnimationContext.beginGrouping()
        NSAnimationContext.current.duration = 0.3
        contentView.animator().setBoundsOrigin(contentOffset)
        reflectScrolledClipView(contentView)
        NSAnimationContext.endGrouping()
        
        if oldOffset != contentOffset {
            flashScrollers()
        }
    }
    
    func subscribeToContentOffset(_ sink: @escaping () -> Void) -> AnyCancellable {
        contentView.postsFrameChangedNotifications = true
        
        return NotificationCenter.default
            .publisher(for: NSView.boundsDidChangeNotification)
            .filter { [weak self] x in
                guard let self,
                      let view = x.object as? NSView
                else { return false }
                
                return view == self.contentView
            }
            .sink { _ in sink() }
    }
    
    func subscribeToContentSize(_ sink: @escaping () -> Void) -> AnyCancellable? {
        nil
    }
}

#endif
