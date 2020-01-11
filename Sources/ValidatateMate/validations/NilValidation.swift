public struct NotNilError: ValidationError {
  public let failureDescription: String? = "is nil"
}

public struct NilError: ValidationError {
  public let failureDescription: String? = "is not nil"
}

public extension Validation {
  static func isNilOr(_ validation: Validation<T>) -> Validation<T?> {
    Validation<T?> {
      if let value = $0 {
        return validation.validate(value)
      } else {
        return .success("is nil")
      }
    }
  }
  
  static func isNotNilAnd(_ validation: Validation<T>) -> Validation<T?> {
    Validation<T?> {
      if let value = $0 {
        return validation.validate(value)
      } else {
        return .failure(.init(NotNilError()))
      }
    }
  }
  
  static var isNil: Validation<T?> {
    Validation<T?> {
      if $0 == nil {
        return .success("is nil")
      } else {
        return .failure(.init(NotNilError()))
      }
    }
  }
  
  static var isNotNil: Validation<T?> {
    Validation<T?> {
      if $0 != nil {
        return .success("is nil")
      } else {
        return .failure(.init(NilError()))
      }
    }
  }
}
