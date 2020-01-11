import Foundation

public struct NotInCharacterSetError: ValidationError {
  public let failureDescription: String?
  
  init(failureDescription: String? = nil) {
    self.failureDescription = failureDescription
  }
}

public struct IsNumericError: ValidationError {
  public let failureDescription: String? = "is not numeric"
}

public struct IsIntegerError: ValidationError {
  public let failureDescription: String? = "is not an integer"
}

public extension Validation where T == String {
  static func inCharacterSet(_ characterSet: CharacterSet,
                             customError: ValidationError? = nil,
                             successMessage: String? = nil) -> Validation<T>
  {
    Validation {
      if let range = $0.rangeOfCharacter(from: characterSet.inverted) {
        let message = "contains an invalid character: '\($0[range])'"
        let error = customError ?? NotInCharacterSetError(failureDescription: message)
        return .failure(.init(error))
      } else {
        let message = successMessage ?? "contains valid characters for character set: \(characterSet)"
        return .success(message)
      }
    }
  }
  
  static var isNumeric: Validation<T> {
    .inCharacterSet(CharacterSet(charactersIn: "0123456789."),
                    customError: IsNumericError(),
                    successMessage: "is numeric")
  }
  
  static var isInteger: Validation<T> {
    .inCharacterSet(CharacterSet(charactersIn: "0123456789"),
                    customError: IsIntegerError(),
                    successMessage: "is an integer")
  }
}
