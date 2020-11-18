//
//  UserDefaultsTypes.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/18.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import Foundation

public enum UserDefaultsTypes {

    public static var prefix = "ChatApp."
}

// MARK: - User
extension UserDefaultsTypes {
    
    enum User: String, UserDefaultsType {
        case id
        
        var name: String {
            return UserDefaultsTypes.prefix + "User" + self.rawValue
        }
    }
}


