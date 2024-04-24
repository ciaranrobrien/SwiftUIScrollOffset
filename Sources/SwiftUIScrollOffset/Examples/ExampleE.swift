/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

/// Use `ScrollOffset.proxy` to read an offset, or programmatically scroll to an offset, outside of a view.
private struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            List {
                Section {
                    ForEach(0..<100) { number in
                        Text(verbatim: "\(number)")
                    }
                }
            }
            .scrollOffsetID(viewModel.scrollOffsetID)
            
            Button("Scroll Down") {
                viewModel.scrollDown()
            }
            .padding()
        }
    }
}


private final class ViewModel: ObservableObject {
    let scrollOffsetID = UUID()
    
    @MainActor
    func scrollDown() {
        let proxy = ScrollOffset.proxy(.top, id: scrollOffsetID)
        let offset = proxy.offset - 32
        
        proxy.scrollTo(offset, withAnimation: true)
    }
}
