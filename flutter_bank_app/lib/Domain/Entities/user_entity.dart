class UserEntity {
  final int? idUser;
  final String name;
  final String surname;
  final String email;
  final String? password;
  final String? dni;
  final String? age;

  UserEntity({
    this.idUser,
    required this.name,
    required this.surname,
    required this.email,
    this.password,
    this.dni,
    this.age,
  });
}
