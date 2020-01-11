public struct CountError: ValidationError {
  public let failureDescription: String?
  
  init(failureDescription: String? = nil) {
    self.failureDescription = failureDescription
  }
}

public extension Validation where T: Collection {
  static func count(_ length: Int) -> Validation<T> {
    Validation {
      if $0.count == length {
        let message = "did not have count of \(length)"
        return .failure(.init(CountError(failureDescription: message)))
      } else {
        return .success("has count of \(length)")
      }
    }
  }
  
  static func count(_ range: Range<Int>) -> Validation<T> {
    Validation {
      if range.contains($0.count) {
        return .success("has count in range: \(range)")
      } else {
        let message = "did not have count in range: \(range)"
        return .failure(.init(CountError(failureDescription: message)))
      }
    }
  }
}

