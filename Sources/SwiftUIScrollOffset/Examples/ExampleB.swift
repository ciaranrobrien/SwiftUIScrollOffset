/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Child views can read scroll offsets from outside of the scroll container.
private struct ContentView: View {
    var body: some View {
        ScrollView {
            Rectangle()
                .fill(.blue.opacity(0.1))
                .frame(height: 1200)
        }
        .overlay(ChildView())
        .scrollOffsetID(.automatic)
    }
}


/// Provide a range to `ScrollOffset` to clamp the scroll offset. This prevents view updates for changes outside of this range.
private struct ChildView: View {
    @ScrollOffset(.top, in: -20...0) private var scrollOffset
    
    var body: some View {
        Text(verbatim: "\(scrollOffset)")
    }
}
