//
//  UserDefaultsDataStore.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/18.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import Foundation

public enum UserDefaultsDataStoreProvider {

    public static func provide() -> UserDefaultsDataStore {
        return UserDefaultsDataStoreImpl(userDefaults: UserDefaults.standard)
    }
}

public protocol UserDefaultsDataStore {
    func get<T>(type: UserDefaultsType) -> T?
    func set<T>(_ value: T?, type: UserDefaultsType)
    func remove(type: UserDefaultsType)
}

private struct UserDefaultsDataStoreImpl: UserDefaultsDataStore {

    let userDefaults: UserDefaults
    
    func get<T>(type: UserDefaultsType) -> T? {
        return self.userDefaults.object(forKey: type.name) as? T
    }
    
    func set<T>(_ value: T?, type: UserDefaultsType) {
        self.userDefaults.set(value, forKey: type.name)
    }
    
    func remove(type: UserDefaultsType) {
        self.userDefaults.removeObject(forKey: type.name)
    }
}
