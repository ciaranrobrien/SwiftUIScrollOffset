Pod::Spec.new do |s|
s.name             = "SwiftUIScrollOffset"
s.version          = "1.3.6"
s.summary          = "SwiftUIScrollOffset"
s.description      = "Read and update the scroll offset of a SwiftUI List or ScrollView from anywhere in the view hierarchy."
s.homepage         = "https://github.com/ciaranrobrien/SwiftUIScrollOffset"
s.license          = 'MIT'
s.author           = { "Ciaranrobrien" => "https://twitter.com/ciaranrobrien" }
s.source           = { :git => "https://github.com/siteline/swiftui-introspect.git", :tag => 'v' + s.version.to_s }
s.resource_bundle  = {"SwiftUIScrollOffset.privacy"=>"Sources/SwiftUIScrollOffset/PrivacyInfo.xcprivacy"}
s.platform     = :ios, '14.0'
s.requires_arc = true

# If more than one source file: https://guides.cocoapods.org/syntax/podspec.html#source_files
s.source_files = 'Sources/SwiftUIScrollOffset/**/*.{h,m,swift}'
s.dependency 'SwiftUIIntrospect'

end
