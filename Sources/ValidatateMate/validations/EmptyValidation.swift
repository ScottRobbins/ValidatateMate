public struct NonEmptyError: ValidationError {
  public let failureDescription: String?
  
  init(failureDescription: String? = nil) {
    self.failureDescription = failureDescription
  }
}

public extension Validation where T: Collection {
  static var isEmpty: Validation<T> {
    Validation {
      if $0.isEmpty {
        return .success("was not empty")
      } else {
        let message = "was empty"
        return .failure(.init(NonEmptyError(failureDescription: message)))
      }
    }
  }
  
  static var isNotEmpty: Validation<T> {
    return !.isEmpty
  }
}
