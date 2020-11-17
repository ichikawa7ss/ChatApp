//
//  ChatViewController.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/17.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import UIKit

final class ChatViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.register(MyChatTableViewCell.self)
            newValue.register(YourChatTableViewCell.self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row % 2 == 0 {
            let cell = self.myChatCell(tableView.dequeueReusableCell(for: indexPath))
            return cell
        } else {
            let cell = self.yourChatCell(tableView.dequeueReusableCell(for: indexPath))
            return cell
        }
    }
    
    private func myChatCell(_ cell: MyChatTableViewCell)  -> MyChatTableViewCell {
        return cell
    }
    
    private func yourChatCell(_ cell: YourChatTableViewCell)  -> YourChatTableViewCell {
        return cell
    }

}
