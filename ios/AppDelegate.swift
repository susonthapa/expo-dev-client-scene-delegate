//
//  AppDelegate.swift
//  ExpoDevClientTest
//
//  Created by Susan Thapa on 24/12/2024.
//

import Foundation

@UIApplicationMain
class AppDelegate: EXAppDelegateWrapper {
  var rootView: UIView? = nil

  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    self.moduleName = "ExpoDevClientTest"
    self.initialProps = [:]
    
    return true
  }
  
  override func sourceURL(for bridge: RCTBridge) -> URL? {
    return self.bundleURL()
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

  func createRCTRootViewFactory() -> RCTRootViewFactory {
      let configuration = RCTRootViewFactoryConfiguration(
          bundleURL: bundleURL()!,
          newArchEnabled: fabricEnabled(),
          turboModuleEnabled: turboModuleEnabled(),
          bridgelessEnabled: bridgelessEnabled()
      )

      weak var weakSelf = self
      configuration
          .createRootViewWithBridge = { bridge, moduleName, initProps in
              return weakSelf!.createRootView(
                  with: bridge,
                  moduleName: moduleName,
                  initProps: initProps
              )
          }

      configuration.createBridgeWithDelegate = { delegate, launchOptions in
          return weakSelf!.createBridge(
              with: delegate,
              launchOptions: launchOptions
          )
      }
      return ExpoReactRootViewFactory(configuration: configuration)
  }

  func initAppFromScene(_ connectionOptions: UIScene
      .ConnectionOptions) -> Bool
  {
      // If bridge has already been initiated by another scene, there's
      // nothing to do here
      if bridge != nil {
          return false
      }

      if bridge == nil {
          RCTAppSetupPrepareApp(UIApplication.shared, turboModuleEnabled())
          rootViewFactory = createRCTRootViewFactory()
      }

      let initProps = prepareInitialProps()
      rootView = rootViewFactory.view(
          withModuleName: moduleName!,
          initialProperties: initProps,
          launchOptions: connectionOptionsToLaunchOptions(connectionOptions)
      )

      return true
  }

  func prepareInitialProps() -> [String: Any] {
      var initProps = (initialProps as? NSMutableDictionary)?
          .mutableCopy() as? [String: Any] ?? [:]

      #if RCT_NEW_ARCH_ENABLED
          initProps["kRNConcurrentRoot"] = concurrentRootEnabled()
      #endif

      return initProps
  }

  func finishedLaunchingWithOptions(
      window: UIWindow?,
      connectOptions: UIScene.ConnectionOptions
  ) {
      self.window = window!
      let launchOptions = connectionOptionsToLaunchOptions(connectOptions)
      super.application(
          UIApplication.shared,
          didFinishLaunchingWithOptions: launchOptions
      )
  }

  override func bundleURL() -> URL? {
#if DEBUG
    return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: ".expo/.virtual-metro-entry")
  #else
    return NSBundle.main.url(forResource: "main", withExtension: "jsbundle")
  #endif
  }
  
}
