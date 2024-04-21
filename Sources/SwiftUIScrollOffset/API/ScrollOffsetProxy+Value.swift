/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

public extension ScrollOffsetProxy {
    struct Value {
        internal var edges: Edge.Set
        internal var id: AnyHashable?
        internal var resolveOffset: (Edge.Set, Offset) -> ScrollOffsetValue
        
        public nonmutating func scrollTo(_ offset: Offset, withAnimation: Bool = false) {
            guard let id,
                  let oldOffset = ScrollSubscriptionStore.shared[offset: id],
                  let scrollView = ScrollSubscriptionStore.shared[scrollView: id]
            else { return }
            
            let newOffset = resolveOffset(edges, offset)
            var contentOffset = scrollView.contentOffset
            
            if !newOffset.leading.isNaN {
                let change = newOffset.leading - oldOffset.leading
                contentOffset.x += change * (scrollView.isRightToLeft ? -1 : 1)
            }
            if !newOffset.trailing.isNaN {
                let change = newOffset.trailing - oldOffset.trailing
                contentOffset.x -= change * (scrollView.isRightToLeft ? -1 : 1)
            }
            if !newOffset.top.isNaN {
                contentOffset.y += newOffset.top - oldOffset.top
            }
            if !newOffset.bottom.isNaN {
                contentOffset.y -= newOffset.bottom - oldOffset.bottom
            }
            
            scrollView.setContentOffset(contentOffset, animated: withAnimation)
        }
    }
}
