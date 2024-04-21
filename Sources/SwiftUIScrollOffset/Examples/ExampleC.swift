/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Provide a unique identifier to `scrollOffsetID` to read the scroll offset from anywhere in the view hierarchy.
@available(iOS 17, *)
private struct ContentView: View {
    var body: some View {
        VStack {
            ScrollView {
                Rectangle()
                    .fill(.blue.opacity(0.1))
                    .frame(height: 1200)
            }
            .scrollOffsetID("Foo")
            
            SiblingView()
                .padding()
        }
    }
}


/// Use the `projectedValue` of `ScrollOffset` to programmatically scroll to an offset.
@available(iOS 17, *)
private struct SiblingView: View {
    @ScrollOffset(.top, id: "Foo") private var scrollOffset
    
    var body: some View {
        Text(verbatim: "\(scrollOffset)")
        
        Button("Scroll to Top") {
            $scrollOffset.scrollTo(.zero, withAnimation: true)
        }
    }
}
