/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI
import SwiftUIIntrospect
import UIKit

@MainActor
internal struct ScrollOffsetSubscriber: ViewModifier {
    @State private var automaticID = UUID()
    
    var scrollOffsetID: ScrollOffsetID
    
    func body(content: Content) -> some View {
        content
            .environment(\.scrollPublisherID, id)
            .introspect(.scrollView, on: .visionOS(.v1)) { scrollView in
                ScrollSubscriptionStore.shared.subscribe(id: id, scrollView: scrollView)
            }
            .introspect(.scrollView, on: .iOS(.v17)) { scrollView in
                ScrollSubscriptionStore.shared.subscribe(id: id, scrollView: scrollView)
            }
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .hidden()
                        .onChange(of: geometry.frame(in: .global), initial: true) {
                            ScrollSubscriptionStore.shared.updateOffset(for: id)
                        }
                }
            )
            .onChange(of: id, initial: true) { oldID, newID in
                ScrollSubscriptionStore.shared.updateSubscription(from: oldID, to: newID)
            }
            .onDisappear {
                ScrollSubscriptionStore.shared.unsubscribe(id: id)
            }
    }
    
    private var id: AnyHashable {
        scrollOffsetID.id ?? AnyHashable(automaticID)
    }
}
