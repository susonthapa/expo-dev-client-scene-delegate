//
//  AppDelegate.swift
//  ExpoDevClientTest
//
//  Created by Susan Thapa on 24/12/2024.
//

import Foundation

@UIApplicationMain
class AppDelegate: EXAppDelegateWrapper {
  
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    self.moduleName = "ExpoDevClientTest"
    self.initialProps = [:]
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func sourceURL(for bridge: RCTBridge) -> URL? {
    return self.bundleURL()
  }
  
  override func bundleURL() -> URL? {
#if DEBUG
    return RCTBundleURLProvider.sharedSettings().jsBundleURL(forBundleRoot: ".expo/.virtual-metro-entry")
  #else
    return NSBundle.main.url(forResource: "main", withExtension: "jsbundle")
  #endif
  }
  
}
