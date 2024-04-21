# SwiftUI Scroll Offset

Read and update the scroll offset from a SwiftUI `List` or `ScrollView`.

## Get Started
Use the `scrollOffsetID` modifier to allow any child view to read the first scroll container's offset.

```swift
struct ContentView: View {
    var body: some View {
        ScrollView {
            ChildView()
        }
        .scrollOffsetID(.automatic)
    }
}
```

Use `ScrollOffset` to read the scroll offset from the provided edge. The scroll offset is calculated relative to any safe area insets.
```swift
struct ChildView: View {
    @ScrollOffset(.top) private var scrollOffset
    
    var body: some View {
        Text(verbatim: "\(scrollOffset)")
    }
}
```

## Requirements

* iOS 14.0+, visionOS 1.0+
* Xcode 15.0+

## Installation

* Install with [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
* Import `SwiftUIScrollOffset` to start using.

## Contact

[@ciaranrobrien](https://twitter.com/ciaranrobrien) on Twitter.
