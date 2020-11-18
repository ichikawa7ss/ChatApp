//
//  UserIdRepository.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/18.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import Foundation

public enum UserIdRepositoryProvider {

    public static func provide() -> UserIdRepository {
        return UserIdRepositoryImpl(userDefaultsDataStore: UserDefaultsDataStoreProvider.provide())
    }
}

public protocol UserIdRepository {
    func getUserId() -> String?
    func saveUserId(_ userId: String)
}

private struct UserIdRepositoryImpl: UserIdRepository {

    let userDefaultsDataStore: UserDefaultsDataStore

    func getUserId() -> String? {
        return self.userDefaultsDataStore.get(type: UserDefaultsTypes.User.id)
    }

    func saveUserId(_ userId: String) {
        self.userDefaultsDataStore.set(userId, type: UserDefaultsTypes.User.id)
    }
}
