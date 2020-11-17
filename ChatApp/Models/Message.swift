// swiftlint:disable all
import Amplify
import Foundation

public struct Message: Model {
  public let id: String
  public var text: String
  public var ts: Double
  public var user: String
  
  public init(id: String = UUID().uuidString,
      text: String,
      ts: Double,
      user: String) {
      self.id = id
      self.text = text
      self.ts = ts
      self.user = user
  }
}