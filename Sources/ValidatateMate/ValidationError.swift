public protocol ValidationError: Error {
  var failureDescription: String? { get }
}

public extension ValidationError {
  var failureDescription: String? { nil }
}
