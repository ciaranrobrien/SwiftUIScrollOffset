/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI
import SwiftUIIntrospect
import UIKit

@MainActor
@available(iOS 17, *)
internal struct ScrollOffsetPublisherModifier: ViewModifier {
    @State private var state = ScrollOffsetPublisherState()
    
    var scrollOffsetID: ScrollOffsetID
    
    func body(content: Content) -> some View {
        content
            .introspect(.scrollView, on: .visionOS(.v1), customize: state.subscribe)
            .introspect(.scrollView, on: .iOS(.v17), customize: state.subscribe)
            .environment(\.scrollPublisherID, scrollOffsetID.id ?? state.scrollContainerID)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .hidden()
                        .onChange(of: geometry.frame(in: .global), initial: true, state.update)
                }
            )
            .onChange(of: scrollOffsetID.id, initial: true) { _, newID in
                state.onID(newID)
            }
    }
}
