import 'package:fpdart/fpdart.dart';

extension FpdartTapEitherExtension<E, A> on Either<E, A> {
  Either<E, A> tapLeft(void Function(E) onLeft) => fold(
    (left) {
      onLeft(left);
      return Left(left);
    },
    (right) => Right(right),
  );

  Either<E, A> tapRight(void Function(A) onRight) => fold(
    (left) => Left(left),
    (right) {
      onRight(right);
      return Right(right);
    },
  );
}

extension FpdartTapTaskEitherExtension<L, R> on TaskEither<L, R> {
  TaskEither<L, R> tapLeft(void Function(L) onLeft) => TaskEither(() async {
    final either = await run();
    return either.fold(
      (left) {
        onLeft(left);
        return Left(left);
      },
      (right) => Right(right),
    );
  });

  TaskEither<L, R> tapRight(void Function(R) onRight) => TaskEither(() async {
    final either = await run();
    return either.fold(
      (left) => Left(left),
      (right) {
        onRight(right);
        return Right(right);
      },
    );
  });
}
