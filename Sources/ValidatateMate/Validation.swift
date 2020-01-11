public struct Validation<T> {
  private let validationFunction: (T) -> Result<String?, NestedError>
  
  public init(_ validationFunction: @escaping (T) -> Result<String?, NestedError>) {
    self.validationFunction = validationFunction
  }
  
  public func validate(_ value: T) -> Result<String?, NestedError> {
    validationFunction(value)
  }
}
