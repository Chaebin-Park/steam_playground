abstract class UseCase<Output, Params> {
  Future<Output> execute(Params params);
}