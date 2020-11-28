// swiftlint:disable all
import Amplify
import Foundation

extension Chat {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case text
    case ts
    case user
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let chat = Chat.keys
    
    model.pluralName = "Chats"
    
    model.fields(
      .id(),
      .field(chat.text, is: .required, ofType: .string),
      .field(chat.ts, is: .required, ofType: .string),
      .field(chat.user, is: .required, ofType: .string)
    )
    }
}