//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import RswiftResources
import UIKit

private class BundleFinder {}
let R = _R(bundle: Bundle(for: BundleFinder.self))

struct _R {
  let bundle: Foundation.Bundle

  let entitlements = entitlements()

  var color: color { .init(bundle: bundle) }
  var image: image { .init(bundle: bundle) }
  var info: info { .init(bundle: bundle) }
  var font: font { .init(bundle: bundle) }
  var file: file { .init(bundle: bundle) }
  var storyboard: storyboard { .init(bundle: bundle) }

  func color(bundle: Foundation.Bundle) -> color {
    .init(bundle: bundle)
  }
  func image(bundle: Foundation.Bundle) -> image {
    .init(bundle: bundle)
  }
  func info(bundle: Foundation.Bundle) -> info {
    .init(bundle: bundle)
  }
  func font(bundle: Foundation.Bundle) -> font {
    .init(bundle: bundle)
  }
  func file(bundle: Foundation.Bundle) -> file {
    .init(bundle: bundle)
  }
  func storyboard(bundle: Foundation.Bundle) -> storyboard {
    .init(bundle: bundle)
  }
  func validate() throws {
    try self.font.validate()
    try self.storyboard.validate()
  }

  struct project {
    let developmentRegion = "en"
  }

  /// This `_R.color` struct is generated, and contains static references to 13 colors.
  struct color {
    let bundle: Foundation.Bundle

    /// Color `AccentColor`.
    var accentColor: RswiftResources.ColorResource { .init(name: "AccentColor", path: [], bundle: bundle) }

    /// Color `BlackWhite`.
    var blackWhite: RswiftResources.ColorResource { .init(name: "BlackWhite", path: [], bundle: bundle) }

    /// Color `actionButtonTappedColor`.
    var actionButtonTappedColor: RswiftResources.ColorResource { .init(name: "actionButtonTappedColor", path: [], bundle: bundle) }

    /// Color `active`.
    var active: RswiftResources.ColorResource { .init(name: "active", path: [], bundle: bundle) }

    /// Color `background`.
    var background: RswiftResources.ColorResource { .init(name: "background", path: [], bundle: bundle) }

    /// Color `commonButtonTappedColor`.
    var commonButtonTappedColor: RswiftResources.ColorResource { .init(name: "commonButtonTappedColor", path: [], bundle: bundle) }

    /// Color `inactive`.
    var inactive: RswiftResources.ColorResource { .init(name: "inactive", path: [], bundle: bundle) }

    /// Color `purple`.
    var purple: RswiftResources.ColorResource { .init(name: "purple", path: [], bundle: bundle) }

    /// Color `red`.
    var red: RswiftResources.ColorResource { .init(name: "red", path: [], bundle: bundle) }

    /// Color `secondary`.
    var secondary: RswiftResources.ColorResource { .init(name: "secondary", path: [], bundle: bundle) }

    /// Color `separator`.
    var separator: RswiftResources.ColorResource { .init(name: "separator", path: [], bundle: bundle) }

    /// Color `subtitle`.
    var subtitle: RswiftResources.ColorResource { .init(name: "subtitle", path: [], bundle: bundle) }

    /// Color `title`.
    var title: RswiftResources.ColorResource { .init(name: "title", path: [], bundle: bundle) }
  }

  /// This `_R.image` struct is generated, and contains static references to 32 images.
  struct image {
    let bundle: Foundation.Bundle

    /// Image `background1Dark`.
    var background1Dark: RswiftResources.ImageResource { .init(name: "background1Dark", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `background1Light`.
    var background1Light: RswiftResources.ImageResource { .init(name: "background1Light", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `background2Dark`.
    var background2Dark: RswiftResources.ImageResource { .init(name: "background2Dark", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `background2Light`.
    var background2Light: RswiftResources.ImageResource { .init(name: "background2Light", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `background3Light`.
    var background3Light: RswiftResources.ImageResource { .init(name: "background3Light", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `background4Light`.
    var background4Light: RswiftResources.ImageResource { .init(name: "background4Light", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `background5Light`.
    var background5Light: RswiftResources.ImageResource { .init(name: "background5Light", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `background6Light`.
    var background6Light: RswiftResources.ImageResource { .init(name: "background6Light", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `backgroundSPBU`.
    var backgroundSPBU: RswiftResources.ImageResource { .init(name: "backgroundSPBU", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `checkmark_circle`.
    var checkmark_circle: RswiftResources.ImageResource { .init(name: "checkmark_circle", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `chevronDown`.
    var chevronDown: RswiftResources.ImageResource { .init(name: "chevronDown", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `circle`.
    var circle: RswiftResources.ImageResource { .init(name: "circle", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `clock`.
    var clock: RswiftResources.ImageResource { .init(name: "clock", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `github_icon`.
    var github_icon: RswiftResources.ImageResource { .init(name: "github_icon", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `icon`.
    var icon: RswiftResources.ImageResource { .init(name: "icon", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `info_circle`.
    var info_circle: RswiftResources.ImageResource { .init(name: "info_circle", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `minus_circle`.
    var minus_circle: RswiftResources.ImageResource { .init(name: "minus_circle", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `notification_point`.
    var notification_point: RswiftResources.ImageResource { .init(name: "notification_point", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `nullBackground`.
    var nullBackground: RswiftResources.ImageResource { .init(name: "nullBackground", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `person_2_gobackward`.
    var person_2_gobackward: RswiftResources.ImageResource { .init(name: "person_2_gobackward", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `person_crop_circle_fill`.
    var person_crop_circle_fill: RswiftResources.ImageResource { .init(name: "person_crop_circle_fill", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `plus_circle_fill`.
    var plus_circle_fill: RswiftResources.ImageResource { .init(name: "plus_circle_fill", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `rectangle_portrait_and_arrow_forward`.
    var rectangle_portrait_and_arrow_forward: RswiftResources.ImageResource { .init(name: "rectangle_portrait_and_arrow_forward", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `square_and_arrow_up`.
    var square_and_arrow_up: RswiftResources.ImageResource { .init(name: "square_and_arrow_up", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `star`.
    var star: RswiftResources.ImageResource { .init(name: "star", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `star_fill`.
    var star_fill: RswiftResources.ImageResource { .init(name: "star_fill", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `tg_icon`.
    var tg_icon: RswiftResources.ImageResource { .init(name: "tg_icon", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `theme`.
    var theme: RswiftResources.ImageResource { .init(name: "theme", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `vk_icon`.
    var vk_icon: RswiftResources.ImageResource { .init(name: "vk_icon", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `warning1`.
    var warning1: RswiftResources.ImageResource { .init(name: "warning1", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `warning2`.
    var warning2: RswiftResources.ImageResource { .init(name: "warning2", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }

    /// Image `warning3`.
    var warning3: RswiftResources.ImageResource { .init(name: "warning3", path: [], bundle: bundle, locale: nil, onDemandResourceTags: nil) }
  }

  /// This `_R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    let bundle: Foundation.Bundle
    var uiApplicationSceneManifest: uiApplicationSceneManifest { .init(bundle: bundle) }

    func uiApplicationSceneManifest(bundle: Foundation.Bundle) -> uiApplicationSceneManifest {
      .init(bundle: bundle)
    }

    struct uiApplicationSceneManifest {
      let bundle: Foundation.Bundle

      let uiApplicationSupportsMultipleScenes: Bool = false

      var _key: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest"], key: "_key") ?? "UIApplicationSceneManifest" }
      var uiSceneConfigurations: uiSceneConfigurations { .init(bundle: bundle) }

      func uiSceneConfigurations(bundle: Foundation.Bundle) -> uiSceneConfigurations {
        .init(bundle: bundle)
      }

      struct uiSceneConfigurations {
        let bundle: Foundation.Bundle
        var _key: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest", "UISceneConfigurations"], key: "_key") ?? "UISceneConfigurations" }
        var uiWindowSceneSessionRoleApplication: uiWindowSceneSessionRoleApplication { .init(bundle: bundle) }

        func uiWindowSceneSessionRoleApplication(bundle: Foundation.Bundle) -> uiWindowSceneSessionRoleApplication {
          .init(bundle: bundle)
        }

        struct uiWindowSceneSessionRoleApplication {
          let bundle: Foundation.Bundle
          var defaultConfiguration: defaultConfiguration { .init(bundle: bundle) }

          func defaultConfiguration(bundle: Foundation.Bundle) -> defaultConfiguration {
            .init(bundle: bundle)
          }

          struct defaultConfiguration {
            let bundle: Foundation.Bundle
            var uiSceneConfigurationName: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication"], key: "UISceneConfigurationName") ?? "Default Configuration" }
            var uiSceneDelegateClassName: String { bundle.infoDictionaryString(path: ["UIApplicationSceneManifest", "UISceneConfigurations", "UIWindowSceneSessionRoleApplication"], key: "UISceneDelegateClassName") ?? "$(PRODUCT_MODULE_NAME).SceneDelegate" }
          }
        }
      }
    }
  }

  /// This `_R.entitlements` struct is generated, and contains static references to 0 properties.
  struct entitlements {
    let comAppleSecurityAppSandbox: Bool = false
    let comAppleSecurityNetworkClient: Bool = true
    let comAppleSecurityPersonalInformationPhotosLibrary: Bool = true
  }

  /// This `_R.font` struct is generated, and contains static references to 12 fonts.
  struct font: Sequence {
    let bundle: Foundation.Bundle

    /// Font `Roboto-Black`.
    var robotoBlack: RswiftResources.FontResource { .init(name: "Roboto-Black", bundle: bundle, filename: "Roboto-Black.ttf") }

    /// Font `Roboto-BlackItalic`.
    var robotoBlackItalic: RswiftResources.FontResource { .init(name: "Roboto-BlackItalic", bundle: bundle, filename: "Roboto-BlackItalic.ttf") }

    /// Font `Roboto-Bold`.
    var robotoBold: RswiftResources.FontResource { .init(name: "Roboto-Bold", bundle: bundle, filename: "Roboto-Bold.ttf") }

    /// Font `Roboto-BoldItalic`.
    var robotoBoldItalic: RswiftResources.FontResource { .init(name: "Roboto-BoldItalic", bundle: bundle, filename: "Roboto-BoldItalic.ttf") }

    /// Font `Roboto-Italic`.
    var robotoItalic: RswiftResources.FontResource { .init(name: "Roboto-Italic", bundle: bundle, filename: "Roboto-Italic.ttf") }

    /// Font `Roboto-Light`.
    var robotoLight: RswiftResources.FontResource { .init(name: "Roboto-Light", bundle: bundle, filename: "Roboto-Light.ttf") }

    /// Font `Roboto-LightItalic`.
    var robotoLightItalic: RswiftResources.FontResource { .init(name: "Roboto-LightItalic", bundle: bundle, filename: "Roboto-LightItalic.ttf") }

    /// Font `Roboto-Medium`.
    var robotoMedium: RswiftResources.FontResource { .init(name: "Roboto-Medium", bundle: bundle, filename: "Roboto-Medium.ttf") }

    /// Font `Roboto-MediumItalic`.
    var robotoMediumItalic: RswiftResources.FontResource { .init(name: "Roboto-MediumItalic", bundle: bundle, filename: "Roboto-MediumItalic.ttf") }

    /// Font `Roboto-Regular`.
    var robotoRegular: RswiftResources.FontResource { .init(name: "Roboto-Regular", bundle: bundle, filename: "Roboto-Regular.ttf") }

    /// Font `Roboto-Thin`.
    var robotoThin: RswiftResources.FontResource { .init(name: "Roboto-Thin", bundle: bundle, filename: "Roboto-Thin.ttf") }

    /// Font `Roboto-ThinItalic`.
    var robotoThinItalic: RswiftResources.FontResource { .init(name: "Roboto-ThinItalic", bundle: bundle, filename: "Roboto-ThinItalic.ttf") }

    func makeIterator() -> IndexingIterator<[RswiftResources.FontResource]> {
      [robotoBlack, robotoBlackItalic, robotoBold, robotoBoldItalic, robotoItalic, robotoLight, robotoLightItalic, robotoMedium, robotoMediumItalic, robotoRegular, robotoThin, robotoThinItalic].makeIterator()
    }
    func validate() throws {
      for font in self {
        if !font.canBeLoaded() { throw RswiftResources.ValidationError("[R.swift] Font '\(font.name)' could not be loaded, is '\(font.filename)' added to the UIAppFonts array in this targets Info.plist?") }
      }
    }
  }

  /// This `_R.file` struct is generated, and contains static references to 14 resource files.
  struct file {
    let bundle: Foundation.Bundle

    /// Resource file `README.md`.
    var readmeMd: RswiftResources.FileResource { .init(name: "README", pathExtension: "md", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-Black.ttf`.
    var robotoBlackTtf: RswiftResources.FileResource { .init(name: "Roboto-Black", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-BlackItalic.ttf`.
    var robotoBlackItalicTtf: RswiftResources.FileResource { .init(name: "Roboto-BlackItalic", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-Bold.ttf`.
    var robotoBoldTtf: RswiftResources.FileResource { .init(name: "Roboto-Bold", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-BoldItalic.ttf`.
    var robotoBoldItalicTtf: RswiftResources.FileResource { .init(name: "Roboto-BoldItalic", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-Italic.ttf`.
    var robotoItalicTtf: RswiftResources.FileResource { .init(name: "Roboto-Italic", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-Light.ttf`.
    var robotoLightTtf: RswiftResources.FileResource { .init(name: "Roboto-Light", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-LightItalic.ttf`.
    var robotoLightItalicTtf: RswiftResources.FileResource { .init(name: "Roboto-LightItalic", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-Medium.ttf`.
    var robotoMediumTtf: RswiftResources.FileResource { .init(name: "Roboto-Medium", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-MediumItalic.ttf`.
    var robotoMediumItalicTtf: RswiftResources.FileResource { .init(name: "Roboto-MediumItalic", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-Regular.ttf`.
    var robotoRegularTtf: RswiftResources.FileResource { .init(name: "Roboto-Regular", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-Thin.ttf`.
    var robotoThinTtf: RswiftResources.FileResource { .init(name: "Roboto-Thin", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `Roboto-ThinItalic.ttf`.
    var robotoThinItalicTtf: RswiftResources.FileResource { .init(name: "Roboto-ThinItalic", pathExtension: "ttf", bundle: bundle, locale: LocaleReference.none) }

    /// Resource file `tasks.md`.
    var tasksMd: RswiftResources.FileResource { .init(name: "tasks", pathExtension: "md", bundle: bundle, locale: LocaleReference.none) }
  }

  /// This `_R.storyboard` struct is generated, and contains static references to 1 storyboards.
  struct storyboard {
    let bundle: Foundation.Bundle
    var launchScreen: launchScreen { .init(bundle: bundle) }

    func launchScreen(bundle: Foundation.Bundle) -> launchScreen {
      .init(bundle: bundle)
    }
    func validate() throws {
      try self.launchScreen.validate()
    }


    /// Storyboard `LaunchScreen`.
    struct launchScreen: RswiftResources.StoryboardReference, RswiftResources.InitialControllerContainer {
      typealias InitialController = UIKit.UIViewController

      let bundle: Foundation.Bundle

      let name = "LaunchScreen"
      func validate() throws {
        if UIKit.UIImage(named: "icon", in: bundle, compatibleWith: nil) == nil { throw RswiftResources.ValidationError("[R.swift] Image named 'icon' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
      }
    }
  }
}