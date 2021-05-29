
struct Promise {
  typealias ResolveClosure = (Any) -> Void
  typealias RejectClosure = (String, String, Error) -> Void

  var resolve: ResolveClosure
  var reject: RejectClosure
}
