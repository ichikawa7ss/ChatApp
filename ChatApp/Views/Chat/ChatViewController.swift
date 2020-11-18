//
//  ChatViewController.swift
//  ChatApp
//
//  Created by ichikawa on 2020/11/17.
//  Copyright © 2020 ichikawa. All rights reserved.
//

import UIKit
import Amplify

final class ChatViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        willSet {
            newValue.register(MyChatTableViewCell.self)
            newValue.register(YourChatTableViewCell.self)
        }
    }
    
    @IBOutlet private weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tappedSendButton() {
        // create messeage
        guard let text = self.textField.text else { return }
        let ts = String(Date().timeIntervalSince1970)
        let user = UserIdRepositoryProvider.provide().getUserId()
        let messsage = Message(text: text, ts: ts, user: user!)
        Amplify.API.mutate(request: .create(messsage)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let message):
                    print("Successfully created the message: \(message)")
                case .failure(let graphQLError): // graphqlの作成に失敗した場合
                    print("Failed to create graphql \(graphQLError)")
                }
            case .failure(let apiError): // 通信などAPIErrorになった場合
                print("Failed to create a message", apiError)
            }
        }
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
