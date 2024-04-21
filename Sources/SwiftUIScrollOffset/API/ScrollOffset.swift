/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

@propertyWrapper public struct ScrollOffset: DynamicProperty {
    @Environment(\.scrollPublisherID) private var scrollPublisherID
    @StateObject private var state = ScrollOffsetState()
    private var edge: Edge
    private var range: ClosedRange<CGFloat>
    private var scrollOffsetID: ScrollOffsetID
    
    public var wrappedValue: CGFloat {
        state.value
    }
    
    public var projectedValue: ScrollOffsetProxy<CGFloat>.Value {
        ScrollOffsetProxy.Value(edge: edge, id: scrollOffsetID.id ?? scrollPublisherID)
    }
    
    public func update() {
        state.update(edge: edge, id: scrollOffsetID.id ?? scrollPublisherID, range: range)
    }
}


public extension ScrollOffset {
    init(_ edge: Edge, in range: ClosedRange<CGFloat> = -CGFloat.infinity...CGFloat.infinity, id: ScrollOffsetID = .automatic) {
        self.edge = edge
        self.range = range
        self.scrollOffsetID = id
    }
    
    init(_ edge: Edge, in range: PartialRangeFrom<CGFloat>, id: ScrollOffsetID = .automatic) {
        self.edge = edge
        self.range = range.lowerBound...CGFloat.infinity
        self.scrollOffsetID = id
    }
    
    init(_ edge: Edge, in range: PartialRangeThrough<CGFloat>, id: ScrollOffsetID = .automatic) {
        self.edge = edge
        self.range = -CGFloat.infinity...range.upperBound
        self.scrollOffsetID = id
    }
    
    init(_ edge: Edge, in range: ClosedRange<CGFloat> = -CGFloat.infinity...CGFloat.infinity, id: some Hashable) {
        self.edge = edge
        self.range = range
        self.scrollOffsetID = .custom(id)
    }
    
    init(_ edge: Edge, in range: PartialRangeFrom<CGFloat>, id: some Hashable) {
        self.edge = edge
        self.range = range.lowerBound...CGFloat.infinity
        self.scrollOffsetID = .custom(id)
    }
    
    init(_ edge: Edge, in range: PartialRangeThrough<CGFloat>, id: some Hashable) {
        self.edge = edge
        self.range = -CGFloat.infinity...range.upperBound
        self.scrollOffsetID = .custom(id)
    }
}
