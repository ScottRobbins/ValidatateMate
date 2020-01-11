public struct EmailError: ValidationError {
  public let failureDescription: String? = "not a valid email address"
}

public extension Validation where T: StringProtocol {
  static var email: Validation<T> {
    .regex("[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}",
           customError: EmailError(),
           successMessage: "is a valid email address")
  }
}
