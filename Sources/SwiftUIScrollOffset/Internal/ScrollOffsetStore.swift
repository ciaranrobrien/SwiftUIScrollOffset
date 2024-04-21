/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import Combine
import UIKit

internal final class ScrollOffsetStore {
    static let shared = ScrollOffsetStore()
    private init() {}
    
    let offsetChangedSubject = PassthroughSubject<AnyHashable, Never>()
    
    subscript(offset id: AnyHashable) -> ScrollOffsetValue? {
        get {
            offsets[id]
        }
        set {
            guard newValue != offsets[id]
            else { return }
            
            if let newValue {
                offsets[id] = newValue
            } else {
                offsets.removeValue(forKey: id)
            }
            
            offsetChangedSubject.send(id)
        }
    }
    
    subscript(scrollView id: AnyHashable) -> UIScrollView? {
        get {
            guard let weakScrollView = scrollViews[id]
            else { return nil }
            
            if let scrollView = weakScrollView.object {
                return scrollView
            } else {
                scrollViews.removeValue(forKey: id)
                return nil
            }
        }
        set {
            if let newValue {
                scrollViews[id] = Weak(newValue)
            } else {
                scrollViews.removeValue(forKey: id)
            }
        }
    }
    
    private var offsets = [AnyHashable : ScrollOffsetValue]()
    private var scrollViews = [AnyHashable : Weak<UIScrollView>]()
}
