/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Combine
import UIKit

internal final class ScrollSubscriptionStore {
    static let shared = ScrollSubscriptionStore()
    private init() {}
    
    let offsetChangedSubject = PassthroughSubject<AnyHashable, Never>()
    
    subscript(offset id: AnyHashable) -> ScrollOffsetValue? {
        subscriptions[id]?.offset
    }
    
    subscript(scrollView id: AnyHashable) -> UIScrollView? {
        guard let subscription = subscriptions[id]
        else { return nil }
        
        if let scrollView = subscription.scrollView {
            return scrollView
        } else {
            subscriptions.removeValue(forKey: id)
            return nil
        }
    }
    
    @MainActor
    func subscribe(id: AnyHashable, scrollView: UIScrollView) {
        guard self[scrollView: id] != scrollView
        else { return }
        
        let contentOffsetCancellable = scrollView
            .publisher(for: \.contentOffset, options: [.initial, .new])
            .didChange()
            .sink { self.updateOffset(for: id) }
        
        let contentSizeCancellable = scrollView
            .publisher(for: \.contentSize, options: [.initial, .new])
            .didChange()
            .sink { self.updateOffset(for: id) }
        
        subscriptions[id] = ScrollSubscription(
            contentOffsetCancellable: contentOffsetCancellable,
            contentSizeCancellable: contentSizeCancellable,
            scrollView: scrollView
        )
        
        updateOffset(for: id)
    }
    
    @MainActor
    func unsubscribe(id: AnyHashable) {
        subscriptions.removeValue(forKey: id)
    }
    
    @MainActor
    func updateOffset(for id: AnyHashable) {
        guard let scrollView = self[scrollView: id] else { return }
        
        let top = -scrollView.adjustedDirectionalContentInset.top - scrollView.contentOffset.y
        let bottom = scrollView.contentSize.height
        - (scrollView.bounds.height - scrollView.adjustedDirectionalContentInset.bottom)
        - scrollView.contentOffset.y
        
        let leading = -scrollView.adjustedDirectionalContentInset.leading - scrollView.contentOffset.x
        let trailing = scrollView.contentSize.width
        - (scrollView.bounds.width - scrollView.adjustedDirectionalContentInset.trailing)
        - scrollView.contentOffset.x
        
        let currentValue = self[offset: id]
        let displayScale = scrollView.traitCollection.displayScale
        
        let (resolvedTop, didTopChange) = resolve(top, oldValue: currentValue?.top, scale: displayScale)
        let (resolvedLeading, didLeadingChange) = resolve(-leading, oldValue: currentValue?.leading, scale: displayScale)
        let (resolvedBottom, didBottomChange) = resolve(-bottom, oldValue: currentValue?.bottom, scale: displayScale)
        let (resolvedTrailing, didTrailingChange) = resolve(-trailing, oldValue: currentValue?.trailing, scale: displayScale)
        
        if didTopChange || didLeadingChange || didBottomChange || didTrailingChange {
            subscriptions[id]?.offset = ScrollOffsetValue(
                top: resolvedTop,
                leading: resolvedLeading,
                bottom: resolvedBottom,
                trailing: resolvedTrailing
            )
            offsetChangedSubject.send(id)
        }
    }
    
    @MainActor
    func updateSubscription(from oldID: AnyHashable, to newID: AnyHashable) {
        subscriptions[newID] = subscriptions[oldID]
        unsubscribe(id: oldID)
    }
    
    private var subscriptions = [AnyHashable : ScrollSubscription]()
    
    private func resolve(_ first: CGFloat, oldValue second: CGFloat?, scale displayScale: CGFloat) -> (CGFloat, Bool) {
        let firstRounded = Int(round(first * displayScale))
        let secondRounded: Int? = if let second { Int(round(second * displayScale)) } else { nil }
        
        let rounded = CGFloat(firstRounded) / displayScale
        let didChange = firstRounded != secondRounded
        return (rounded, didChange)
    }
}
