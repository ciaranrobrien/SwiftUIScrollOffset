/**
*  SwiftUIScrollOffset
*  Copyright (c) Ciaran O'Brien 2024
*  MIT license, see LICENSE file for details
*/


import Foundation

internal final class Weak<Object>
where Object : AnyObject
{
    weak var object: Object?
    init(_ object: Object) {
        self.object = object
    }
}
