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
    
    var messages: [Message] = []
    
    var subscription: GraphQLSubscriptionOperation<Message>?
    
    var myId: String {
        return UserIdRepositoryProvider.provide().getUserId() ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchMessage()
        self.subscribeMessage()
    }
    
    @IBAction func tappedSendButton() {
        self.textField.text = ""
        self.textField.resignFirstResponder()
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
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Successfully created the message: \(message)")
                case .failure(let graphQLError): // graphqlの作成に失敗した場合
                    print("Failed to create graphql \(graphQLError)")
                }
            case .failure(let apiError): // 通信などAPIErrorになった場合
                print("Failed to create a message", apiError)
            }
        }
    }
    
    func fetchMessage() {
        Amplify.API.query(request: .list(Message.self, where: nil)) { event in
            switch event {
            case .success(let result):
                switch result {
                case .success(let messages):
                    self.messages = messages
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
    
    func subscribeMessage() {
        subscription = Amplify.API.subscribe(request: .subscription(of: Message.self, type: .onCreate), valueListener: { (subscriptionEvent) in
            switch subscriptionEvent {
            case .connection(let subscriptionConnectionState):
                print("Subscription connect state is \(subscriptionConnectionState)")
            case .data(let result):
                switch result {
                case .success(let createdMessage):
                    self.messages.append(createdMessage)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
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
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = messages[safe: indexPath.row] else { return UITableViewCell() }
        if message.user == myId {
            let cell = self.myChatCell(tableView.dequeueReusableCell(for: indexPath), text: message.text)
            return cell
        } else {
            let cell = self.yourChatCell(tableView.dequeueReusableCell(for: indexPath), text: message.text)
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
