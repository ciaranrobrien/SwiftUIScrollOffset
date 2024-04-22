/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use the `scrollOffsetID` modifier to allow any child view to read the first scroll container's offset.
private struct ContentView: View {
    var body: some View {
        ScrollView {
            ChildView()
        }
        .scrollOffsetID(.automatic)
    }
}


/// Use `ScrollOffset` to read the scroll offset from the provided edge.
/// The scroll offset is calculated relative to any safe area insets.
private struct ChildView: View {
    @ScrollOffset(.top) private var scrollOffset
    
    var body: some View {
        Text(verbatim: "\(scrollOffset)")
    }
}
