/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `ScrollOffsetProxy` to programmatically scroll to an offset without reading the current value.
private struct ContentView: View {
    @ScrollOffsetProxy(.bottom, id: "Foo") private var scrollOffsetProxy
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(0..<100) { number in
                        Text(verbatim: "\(number)")
                    }
                }
            }
            .scrollOffsetID("Foo")
            
            Button("Scroll to Bottom") {
                scrollOffsetProxy.scrollTo(.zero, withAnimation: true)
            }
            .padding()
        }
    }
}