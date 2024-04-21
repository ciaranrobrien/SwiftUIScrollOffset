/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI
import SwiftUIIntrospect
import UIKit

@MainActor
internal struct ScrollOffsetPublisherModifier: ViewModifier {
    @StateObject private var state = ScrollOffsetPublisherState()
    
    var scrollOffsetID: ScrollOffsetID
    
    func body(content: Content) -> some View {
        content
            .introspect(.scrollView, on: .visionOS(.v1), customize: state.subscribe)
            .introspect(.scrollView, on: .iOS(.v14, .v15, .v16, .v17), customize: state.subscribe)
            .environment(\.scrollPublisherID, scrollOffsetID.id ?? state.scrollContainerID)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .hidden()
                        .onAppearAndChange(of: geometry.frame(in: .global)) { _ in
                            state.update()
                        }
                }
            )
            .onAppearAndChange(of: scrollOffsetID.id, state.onID)
    }
}
