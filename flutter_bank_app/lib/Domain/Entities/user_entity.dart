class UserEntity {
  final String? name;
  final String? surname;
  final String email;
  final String? password;
  final String? dni;
  final String? age;

  UserEntity({
    this.name,
    this.surname,
    required this.email,
    this.password,
    this.dni,
    this.age,
  });
}
