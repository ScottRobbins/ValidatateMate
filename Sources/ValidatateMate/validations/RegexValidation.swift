public struct RegexError: ValidationError {
  public let failureDescription: String?
  
  init(failureDescription: String? = nil) {
    self.failureDescription = failureDescription
  }
}

public extension Validation where T: StringProtocol {
  static func regex(_ expression: String,
                    customError: ValidationError? = nil,
                    successMessage: String? = nil) -> Validation<T>
  {
    Validation {
      if let range = $0.range(of: expression, options: [.regularExpression, .caseInsensitive]),
        range.lowerBound == $0.startIndex && range.upperBound == $0.endIndex
      {
        let message = successMessage ?? "satisfies expression: \(expression)"
        return .success(message)
      } else {
        let message = "does not satisfy expression: \(expression)"
        let error = customError ?? RegexError(failureDescription: message)
        return .failure(.init(error))
      }
    }
  }
}
