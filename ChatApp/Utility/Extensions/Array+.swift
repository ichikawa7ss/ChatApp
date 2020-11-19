//
//  Array+.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/19.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import Foundation

extension Array {

    /// 範囲を超えてもクラッシュしない
    public subscript (safe index: Int) -> Element? {
        return self.indices ~= index ? self[index] : nil
    }

    /// 範囲を超えてもクラッシュしない
    public subscript (reverse index: Int) -> Element {
        return self[self.count - index - 1]
    }
}
