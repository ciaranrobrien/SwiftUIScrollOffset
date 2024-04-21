# SwiftUI Scroll Offset

Read and update the scroll offset of a SwiftUI `List` or `ScrollView` from anywhere in the view hierarchy.

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

Child views can read scroll offsets from outside of the scroll container.
```swift
struct ContentView: View {
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
```

Provide a range to `ScrollOffset` to clamp the scroll offset. This can prevent unnecessary view updates.
```swift
@ScrollOffset(.top, in: -20...0) private var scrollOffset
```

## Advanced Usage
Provide a unique identifier to `scrollOffsetID` to read the scroll offset from anywhere in the view hierarchy.
```swift
struct ContentView: View {
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
```

/// Use the `projectedValue` of `ScrollOffset` to programmatically scroll to an offset.
```swift
struct SiblingView: View {
    @ScrollOffset(.top, id: "Foo") private var scrollOffset
    
    var body: some View {
        Text(verbatim: "\(scrollOffset)")
        
        Button("Scroll to Top") {
            $scrollOffset.scrollTo(.zero, withAnimation: true)
        }
    }
}

```

/// Use `ScrollOffsetProxy` to programmatically scroll to an offset without reading the current value.
```swift
struct ContentView: View {
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
```

## Requirements

* iOS 14.0+, visionOS 1.0+
* Xcode 15.0+

## Installation

* Install with [Swift Package Manager](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app).
* Import `SwiftUIScrollOffset` to start using.

## Contact

[@ciaranrobrien](https://twitter.com/ciaranrobrien) on Twitter.
