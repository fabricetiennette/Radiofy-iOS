// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Asset {
  internal static let forwardIcon = ImageAsset(name: "ForwardIcon")
  internal static let settingsIcon = ImageAsset(name: "SettingsIcon")
  internal static let chevronRight = ImageAsset(name: "chevronRight")
  internal static let noPicture = ImageAsset(name: "NoPicture")
  internal static let chevronDown = ImageAsset(name: "chevron-down")
  internal static let forwardTen = ImageAsset(name: "forwardTen")
  internal static let heartIcon = ImageAsset(name: "heartIcon")
  internal static let heartIconFill = ImageAsset(name: "heartIconFill")
  internal static let pauseButton = ImageAsset(name: "pauseButton")
  internal static let playButton = ImageAsset(name: "playButton")
  internal static let replayTen = ImageAsset(name: "replayTen")
  internal static let sliderThumb = ImageAsset(name: "sliderThumb")
  internal static let stopButton = ImageAsset(name: "stopButton")
  internal static let radiofy = ImageAsset(name: "Radiofy")
  internal static let homeIcon = ImageAsset(name: "HomeIcon")
  internal static let homeIconFill = ImageAsset(name: "HomeIconFill")
  internal static let searchIcon = ImageAsset(name: "SearchIcon")
  internal static let searchIconFill = ImageAsset(name: "SearchIconFill")
  internal static let yourLibraryIcon = ImageAsset(name: "YourLibraryIcon")
  internal static let yourLibraryIconFill = ImageAsset(name: "YourLibraryIconFill")
  internal static let podcastsFilled = ImageAsset(name: "podcastsFilled")
  internal static let podcastsLogo = ImageAsset(name: "podcastsLogo")
  internal static let placeholderPicture = ImageAsset(name: "placeholderPicture")
  internal static let r = ImageAsset(name: "r")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
}

internal extension ImageAsset.Image {
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
