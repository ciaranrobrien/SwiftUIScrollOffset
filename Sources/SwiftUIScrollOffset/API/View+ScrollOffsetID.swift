/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

extension View {
    @MainActor
    public func scrollOffsetID(_ id: ScrollOffsetID) -> some View {
        modifier(ScrollOffsetPublisherModifier(scrollOffsetID: id))
    }
    
    @_disfavoredOverload
    @MainActor
    public func scrollOffsetID(_ id: some Hashable) -> some View {
        modifier(ScrollOffsetPublisherModifier(scrollOffsetID: .custom(id)))
    }
}
