/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

extension View {
    @MainActor
    @available(iOS 17, *)
    public func scrollOffsetID(_ id: ScrollOffsetID) -> some View {
        modifier(ScrollOffsetPublisherModifier(scrollOffsetID: id))
    }
    
    @_disfavoredOverload
    @MainActor
    @available(iOS 17, *)
    public func scrollOffsetID(_ id: some Hashable) -> some View {
        modifier(ScrollOffsetPublisherModifier(scrollOffsetID: .custom(id)))
    }
}


extension View {
    public func ignoresScrollOffset(_ isIgnored: Bool = true) -> some View {
        transformEnvironment(\.scrollPublisherID) { id in
            if isIgnored {
                id = nil
            }
        }
    }
}
