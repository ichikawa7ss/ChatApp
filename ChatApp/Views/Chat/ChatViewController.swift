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
    
    var chats: [Chat] = []
    
    var subscription: GraphQLSubscriptionOperation<Chat>?
    
    var myId: String {
        return UserIdRepositoryProvider.provide().getUserId() ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchChat()
        self.subscribeChat()
    }
    
    @IBAction func tappedSendButton() {
        self.textField.resignFirstResponder()
        // create messeage
        guard let text = self.textField.text else { return }
        let ts = String(Date().timeIntervalSince1970)
        let user = UserIdRepositoryProvider.provide().getUserId()
        let chat = Chat(text: text, ts: ts, user: user!)
        Amplify.API.mutate(request: .create(chat)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let chat):
                    // TODO: 送信中っぽいアニメーションをつけたい
                    // できれば通信状態も管理して、送信失敗した場合にも再送するか確認するようなアクションにしたい
                    print("Successfully created the chat: \(chat)")
                case .failure(let graphQLError): // graphqlの作成に失敗した場合
                    print("Failed to create graphql \(graphQLError)")
                }
            case .failure(let apiError): // 通信などAPIErrorになった場合
                print("Failed to create a chat", apiError)
            }
        }
        
        // initialize
        self.textField.text = ""
    }
    
    func fetchChat() {
        Amplify.API.query(request: .list(Chat.self, where: nil)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let chats):
                    self.chats = chats
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            case .failure(let error):
                print("Got failed event with error \(error)")
            }
        }
    }
    
    func subscribeChat() {
        subscription = Amplify.API.subscribe(request: .subscription(of: Chat.self, type: .onCreate), valueListener: { (subscriptionEvent) in
            switch subscriptionEvent {
            case .connection(let subscriptionConnectionState):
                print("Subscription connect state is \(subscriptionConnectionState)")
            case .data(let result):
                switch result {
                case .success(let createdChat):
                    self.chats.append(createdChat)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                        // TODO: 過去のログを見てるときにメッセージが来たらスクロールせずに「メッセージが来てます」的な文言を出したい
                        
                        // 最新のメッセージまでスクロール
                        let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                    }
                case .failure(let error):
                    print("Got failed result with \(error.errorDescription)")
                }
            }
        }) { result in
            switch result {
            case .success:
                print("Subscription has been closed successfully")
            case .failure(let apiError):
                print("Subscription has terminated with \(apiError)")
            }
        }
    }
}

extension ChatViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chat = chats[safe: indexPath.row] else { return UITableViewCell() }
        if chat.user == myId {
            let cell = self.myChatCell(tableView.dequeueReusableCell(for: indexPath), text: chat.text)
            return cell
        } else {
            let cell = self.yourChatCell(tableView.dequeueReusableCell(for: indexPath), text: chat.text)
            return cell
        }
    }
    
    private func myChatCell(_ cell: MyChatTableViewCell, text: String)  -> MyChatTableViewCell {
        cell.setData(text)
        return cell
    }
    
    private func yourChatCell(_ cell: YourChatTableViewCell, text: String)  -> YourChatTableViewCell {
        cell.setData(text)
        return cell
    }

}
