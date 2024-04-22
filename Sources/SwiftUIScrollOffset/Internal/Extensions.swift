/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension Corner {
    var edges: Edge.Set {
        switch self {
        case .topLeading: [.top, .leading]
        case .bottomLeading: [.bottom, .leading]
        case .bottomTrailing: [.bottom, .trailing]
        case .topTrailing: [.top, .trailing]
        }
    }
}


internal extension ScrollOffsetID {
    var id: AnyHashable? {
        switch self {
        case .automatic: nil
        case .custom(let id): id
        }
    }
}


internal extension ScrollOffsetProxy.Value {
    init(edge: Edge, id: AnyHashable?)
    where Offset == CGFloat
    {
        self.edges = Edge.Set(edge)
        self.id = id
        self.resolveOffset = { edges, offset in
            ScrollOffsetValue(
                top: edges.contains(.top) ? offset : .nan,
                leading: edges.contains(.leading) ? offset : .nan,
                bottom: edges.contains(.bottom) ? offset : .nan,
                trailing: edges.contains(.trailing) ? offset : .nan
            )
        }
    }
    
    init(corner: Corner, id: AnyHashable?)
    where Offset == CGPoint
    {
        self.edges = corner.edges
        self.id = id
        self.resolveOffset = { edges, offset in
            ScrollOffsetValue(
                top: edges.contains(.top) ? offset.y : .nan,
                leading: edges.contains(.leading) ? offset.x : .nan,
                bottom: edges.contains(.bottom) ? offset.y : .nan,
                trailing: edges.contains(.trailing) ? offset.x : .nan
            )
        }
    }
}


internal extension UIScrollView {
    var isRightToLeft: Bool {
        effectiveUserInterfaceLayoutDirection == .rightToLeft
    }
}


internal extension EnvironmentValues {
    var scrollPublisherID: AnyHashable? {
        get { self[ScrollPublisherIDKey.self] }
        set { self[ScrollPublisherIDKey.self] = newValue }
    }
}


private struct ScrollPublisherIDKey: EnvironmentKey {
    static let defaultValue: AnyHashable? = nil
}
