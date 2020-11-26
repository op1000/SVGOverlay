//
//  AppDelegate.swift
//  SVGOverlay
//
//  Created by Nakcheon Jung on 2020/11/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #available(iOS 13, *) {
            // do nothing for iOS 13
        } else {
            let storyboard = UIStoryboard(name: "SVGOverlay", bundle: nil)
            let navigaion = storyboard.instantiateViewController(withIdentifier: "AlbumsNavigationController") as? UINavigationController
            guard let rootView = navigaion?.viewControllers.first as? AlbumsViewController else {
                return true
            }
            
            // mvvm
            let viewModel = AlbumsViewModel()
            viewModel.albumsView = rootView
            rootView.albumsViewModel = viewModel
            
            // show
            self.window = UIWindow()
            self.window?.rootViewController = navigaion
            self.window?.makeKeyAndVisible()
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}
