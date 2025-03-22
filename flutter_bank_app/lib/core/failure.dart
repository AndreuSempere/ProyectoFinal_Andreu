abstract class Failure {
  final String? message;

  Failure({this.message});
  
  @override
  String toString() {
    return message ?? 'An error occurred';
  }
}

class ServerFailure extends Failure {
  ServerFailure({super.message});
}

class AuthFailure extends Failure {
  AuthFailure({super.message});
}
