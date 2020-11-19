//
//  YourChatTableViewCell.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/17.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import UIKit

final class YourChatTableViewCell: UITableViewCell {

    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setData(_ text: String) {
        self.label.text = text
    }
    
}
