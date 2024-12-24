//
//  AppDelegate.swift
//  ExpoDevClientTest
//
//  Created by Susan Thapa on 24/12/2024.
//

import Foundation

@UIApplicationMain
class AppDelegate: EXAppDelegateWrapper {
  private var isBridgeInitialized = false

  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    self.moduleName = "ExpoDevClientTest"
    self.initialProps = [:]
    self.automaticallyLoadReactNativeWindow = false
    
    return true
  }
  
  private func connectionOptionsToLaunchOptions(_ connectionOptions: UIScene
      .ConnectionOptions?) -> [UIApplication.LaunchOptionsKey: Any]
  {
      var launchOptions: [UIApplication.LaunchOptionsKey: Any] = [:]

      guard let connectionOptions = connectionOptions else {
          return launchOptions
      }

      // Handle notification response
      if let notificationResponse = connectionOptions.notificationResponse {
          launchOptions[.remoteNotification] = notificationResponse
              .notification
              .request.content.userInfo
      }

      // Handle user activities
      if !connectionOptions.userActivities.isEmpty {
          if let userActivity = connectionOptions.userActivities.first {
              let userActivityDictionary: [String: Any] = [
                  "UIApplicationLaunchOptionsUserActivityTypeKey": userActivity
                      .activityType as Any,
                  "UIApplicationLaunchOptionsUserActivityKey": userActivity,
              ]
              launchOptions[.userActivityDictionary] = userActivityDictionary
          }
      }

      return launchOptions
  }

  func initAppFromScene(_ connectionOptions: UIScene
    .ConnectionOptions, window: UIWindow) -> Bool
  {
      // If bridge has already been initiated by another scene, there's
      // nothing to do here
    if isBridgeInitialized {
          return false
    } else {
      let initProps = prepareInitialProps()
      let launchOptions = connectionOptionsToLaunchOptions(connectionOptions)
      reactDelegate.createReactRootView(moduleName!, initialProperties: initProps, launchOptions: launchOptions)
      self.window = window

      isBridgeInitialized = true
      super.application(
          UIApplication.shared,
          didFinishLaunchingWithOptions: launchOptions
      )
      return true
    }

  }

  func prepareInitialProps() -> [String: Any] {
      var initProps = (initialProps as? NSMutableDictionary)?
          .mutableCopy() as? [String: Any] ?? [:]

      #if RCT_NEW_ARCH_ENABLED
          initProps["kRNConcurrentRoot"] = concurrentRootEnabled()
      #endif

      return initProps
  }

  override func bundleURL() -> URL? {
#if DEBUG
    return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: ".expo/.virtual-metro-entry")
  #else
    return NSBundle.main.url(forResource: "main", withExtension: "jsbundle")
  #endif
  }
  
}
