import Foundation

public struct URLError: ValidationError {
  public let failureDescription: String? = "not a valid url"
}

public extension Validation where T: String {
  static var url: Validation<T> {
    Validation {
      if let url = URL(string: $0),
        url.isFileURL || (url.host != nil && url.scheme != nil)
      {
        return .success("is a valid url")
      } else {
        return .failure(.init(URLError()))
      }
    }
  }
}
