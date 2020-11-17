// swiftlint:disable all
import Amplify
import Foundation

extension Message {
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
    let message = Message.keys
    
    model.pluralName = "Messages"
    
    model.fields(
      .id(),
      .field(message.text, is: .required, ofType: .string),
      .field(message.ts, is: .required, ofType: .double),
      .field(message.user, is: .required, ofType: .string)
    )
    }
}