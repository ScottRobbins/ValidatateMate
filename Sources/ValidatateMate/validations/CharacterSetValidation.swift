import Foundation

public struct CharacterSetError: ValidationError {
  public let failureDescription: String?
  
  init(failureDescription: String? = nil) {
    self.failureDescription = failureDescription
  }
}

public extension Validation where T: String {
  static func characterSet(_ characterSet: CharacterSet) -> Validation<T> {
    Validation {
      if let range = $0.rangeOfCharacter(from: characterSet.inverted) {
        let message = "contains an invalid character: '\($0[range])'"
        return .failure(.init(CharacterSetError(failureDescription: message)))
      } else {
        return .success("contains valid characters for character set: \(characterSet)")
      }
    }
  }
}
