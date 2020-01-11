public struct NotInListError: ValidationError {
  public let failureDescription: String?
  
  init(failureDescription: String? = nil) {
    self.failureDescription = failureDescription
  }
}

public extension Validation where T: Equatable {
  static func `in`(_ array: T...) -> Validation<T> {
    .in(array)
  }
  
  static func `in`(_ array: [T]) -> Validation<T> {
    Validation {
      let list = array.map { "\($0)" }.joined(separator: ",")
      if array.contains($0) {
        return .success("is in \(list)")
      } else {
        let message = "is not in \(list)"
        return .failure(.init(NotInListError(failureDescription: message)))
      }
    }
  }
}
