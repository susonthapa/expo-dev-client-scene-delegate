//
//  SceneDelegate.swift
//  ExpoDevClientTest
//
//  Created by Susan Thapa on 24/12/2024.
//

import Foundation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(
      _ scene: UIScene,
      willConnectTo _: UISceneSession,
      options connectionOptions: UIScene.ConnectionOptions
  ) {
      guard let windowScene = (scene as? UIWindowScene) else { return }
      let delegate = (UIApplication.shared.delegate as! AppDelegate)
      window = UIWindow(windowScene: windowScene)
      delegate.initAppFromScene(connectionOptions, window: window!)
  }

}
