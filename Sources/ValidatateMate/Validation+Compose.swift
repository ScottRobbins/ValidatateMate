extension Validation {
  public static func all(_ validations: Validation<T>...) -> Validation<T> {
    .init { value in
      return validations.reduce(.success(nil)) { result, validator in
        switch validator.validate(value) {
        case .success(let successDescription):
          let resultSuccessDescription = try? result.get()
          let description = [resultSuccessDescription, successDescription]
            .compactMap { $0 }
            .joined(separator: " and ")
          return .success(description.isEmpty ? nil : description)
        case .failure(let validatorErrors):
          switch result {
          case .success:
            return .failure(validatorErrors)
          case .failure(let validatorResultErrors):
            return .failure(.init(validatorResultErrors.errors + validatorErrors.errors))
          }
        }
      }
    }
  }
  
  public static func any(_ validations: [Validation<T>]) -> Validation<T> {
    .init { value in
      let emptyFailure = Result<String?, NestedError>.failure(.init([]))
      return validations.reduce(emptyFailure) { result, validator -> Result<String?, NestedError> in
        switch validator.validate(value) {
        case .success(let successDescription):
          let resultSuccessDescription = try? result.get()
          let description = [resultSuccessDescription, successDescription]
            .compactMap { $0 }
            .joined(separator: " and ")
          return .success(description.isEmpty ? nil : description)
        case .failure(let validatorErrors):
          switch result {
          case .success:
            return result
          case .failure(let validatorResultErrors):
            return .failure(.init(validatorErrors.errors + validatorResultErrors.errors))
          }
        }
      }
    }
  }
  
  public static func any(_ validations: Validation<T>...) -> Validation<T> {
    any(validations)
  }
  
  public static func none(_ validations: Validation<T>...) -> Validation<T> {
    .init { value in
      switch Validation.any(validations).validate(value) {
      case .success(let successDescription):
        return .failure(.init(NoneValidError(failureDescription: successDescription)))
      case .failure(let validatorResultErrors):
        let description = validatorResultErrors
          .errors
          .compactMap { $0.failureDescription }
          .joined(separator: " and ")
        
          return .success(description.isEmpty ? nil : description)
      }
    }
  }
}

public func &&<T> (lhs: Validation<T>, rhs: Validation<T>) -> Validation<T> {
  .all(lhs, rhs)
}

public func ||<T> (lhs: Validation<T>, rhs: Validation<T>) -> Validation<T> {
  .any(lhs, rhs)
}

public prefix func ! <T>(validation: Validation<T>) -> Validation<T> {
  .none(validation)
}

public struct NestedError: ValidationError {
  public let errors: [ValidationError]
  
  public init(_ errors: [ValidationError]) {
    self.errors = errors
  }
  
  public init(_ error: ValidationError) {
    self.init([error])
  }
  
  public var failureDescription: String? {
    let description = errors
      .compactMap { $0.failureDescription }
      .joined(separator: " and ")
    return description.isEmpty ? nil : description
  }
}

public struct NoneValidError: ValidationError {
  public let failureDescription: String?
  
  init(failureDescription: String? = nil) {
    self.failureDescription = failureDescription
  }
}
