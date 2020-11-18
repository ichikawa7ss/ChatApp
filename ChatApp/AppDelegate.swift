//
//  AppDelegate.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/17.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        do {
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: AmplifyModels()))
            try Amplify.configure()
        } catch {
            print("An error occurred setting up Amplify: \(error)")
        }
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = ChatViewController.instantiate()
        self.window?.makeKeyAndVisible()
        
        self.saveUserId()
        return true
    }
}

extension AppDelegate {
    
    func saveUserId() {
        let idManager = UserIdRepositoryProvider.provide()
        if let _ = idManager.getUserId() {
            // あれば何もしない
        }
        else {
            // なければ適当な乱数を保存しておく
            idManager.saveUserId(UUID().uuidString)
        }
    }
}
