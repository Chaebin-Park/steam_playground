abstract class UseCase<Output, Input> {
  Future<Output> execute(Input queryParameters);
}