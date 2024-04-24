/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `ScrollOffsetProxy` to read an offset, or programmatically scroll to an offset, without view updates when the offset changes.
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
