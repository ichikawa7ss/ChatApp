// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "f4b7359b0b7331ba60b763e8595b0d47"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Chat.self)
  }
}