public protocol ValidationError: Error {
  var failureDescription: String? { get }
}

public extension ValidationError {
  var failureDescription: String? { nil }
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
