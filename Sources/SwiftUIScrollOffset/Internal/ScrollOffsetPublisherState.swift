/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Combine
import SwiftUI
import UIKit

internal final class ScrollOffsetPublisherState: NSObject, ObservableObject {
    private var contentOffsetCancellable: AnyCancellable?
    private var contentSizeCancellable: AnyCancellable?
    private var id: AnyHashable?
    private weak var scrollView: UIScrollView?
    
    var isPublishing: Bool {
        contentOffsetCancellable != nil && contentSizeCancellable != nil
    }
    var scrollContainerID: AnyHashable? {
        if let scrollView {
            AnyHashable(ObjectIdentifier(scrollView))
        } else {
            nil
        }
    }
    
    @MainActor
    func onID(_ newValue: AnyHashable?) {
        if let id {
            ScrollOffsetStore.shared[offset: id] = nil
            ScrollOffsetStore.shared[scrollView: id] = nil
        }
        
        id = newValue
        
        if let id {
            ScrollOffsetStore.shared[scrollView: id] = scrollView
        }
        
        update()
    }
    
    @MainActor
    func subscribe(to scrollView: UIScrollView) {
        guard !isPublishing else { return }
        self.scrollView = scrollView
        
        if let id {
            ScrollOffsetStore.shared[scrollView: id] = scrollView
        }
        
        contentOffsetCancellable = scrollView
            .publisher(for: \.contentOffset, options: [.initial, .new])
            .didChange()
            .sink(receiveValue: update)
        
        contentSizeCancellable = scrollView
            .publisher(for: \.contentSize, options: [.initial, .new])
            .didChange()
            .sink(receiveValue: update)
        
        update()
    }
    
    @MainActor
    func update() {
        guard let scrollView else { return }
        
        let top = -scrollView.adjustedDirectionalContentInset.top - scrollView.contentOffset.y
        let bottom = scrollView.contentSize.height
        - (scrollView.bounds.height - scrollView.adjustedDirectionalContentInset.bottom)
        - scrollView.contentOffset.y
        
        let leading = -scrollView.adjustedDirectionalContentInset.leading - scrollView.contentOffset.x
        let trailing = scrollView.contentSize.width
        - (scrollView.bounds.width - scrollView.adjustedDirectionalContentInset.trailing)
        - scrollView.contentOffset.x
        
        let id = id ?? AnyHashable(ObjectIdentifier(scrollView))
        let currentValue = ScrollOffsetStore.shared[offset: id]
        let displayScale = scrollView.traitCollection.displayScale
        
        let (resolvedTop, didTopChange) = resolve(top, oldValue: currentValue?.top, scale: displayScale)
        let (resolvedLeading, didLeadingChange) = resolve(-leading, oldValue: currentValue?.leading, scale: displayScale)
        let (resolvedBottom, didBottomChange) = resolve(-bottom, oldValue: currentValue?.bottom, scale: displayScale)
        let (resolvedTrailing, didTrailingChange) = resolve(-trailing, oldValue: currentValue?.trailing, scale: displayScale)
        
        if didTopChange || didLeadingChange || didBottomChange || didTrailingChange {
            ScrollOffsetStore.shared[offset: id] = ScrollOffsetValue(
                top: resolvedTop,
                leading: resolvedLeading,
                bottom: resolvedBottom,
                trailing: resolvedTrailing
            )
        }
    }
    
    private func resolve(_ first: CGFloat, oldValue second: CGFloat?, scale displayScale: CGFloat) -> (CGFloat, Bool) {
        let firstRounded = Int(round(first * displayScale))
        let secondRounded: Int? = if let second { Int(round(second * displayScale)) } else { nil }
        
        let rounded = CGFloat(firstRounded) / displayScale
        let didChange = firstRounded != secondRounded
        return (rounded, didChange)
    }
    
    deinit {
        if let id {
            ScrollOffsetStore.shared[offset: id] = nil
            ScrollOffsetStore.shared[scrollView: id] = nil
        }
        if let scrollContainerID {
            ScrollOffsetStore.shared[offset: scrollContainerID] = nil
            ScrollOffsetStore.shared[scrollView: scrollContainerID] = nil
        }
    }
}
