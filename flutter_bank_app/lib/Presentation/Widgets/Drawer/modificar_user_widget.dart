// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_twitter_copy/presentation/blocs/Auth/auth_bloc.dart';
// import 'package:flutter_twitter_copy/presentation/blocs/Auth/auth_event.dart';

// class ThemeDialog extends StatefulWidget {
//   const ThemeDialog({super.key});

//   @override
//   DialogoState createState() => DialogoState();
// }

// class DialogoState extends State<ThemeDialog> {
//   final _nameController = TextEditingController();
//   final _avatarController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();

//   @override
//   void initState() {
//     super.initState();
//     final myLoginState = context.read<AuthBloc>().state;
//     if (myLoginState.user != null) {
//       _nameController.text = myLoginState.user!.username;
//       _avatarController.text = myLoginState.user!.avatar;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: const Text('Editar Usuario'),
//       content: Form(
//         key: _formKey,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextFormField(
//               controller: _nameController,
//               decoration: const InputDecoration(labelText: 'Nombre Usuario'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Introduce un nombre de usuario';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: _avatarController,
//               decoration: const InputDecoration(labelText: 'URL del Avatar'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Introduce una URL de avatar';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Navigator.of(context).pop(),
//           child: const Text('Cancelar'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               _formKey.currentState!.save();

//               final myLoginState = context.read<AuthBloc>().state;
//               final userid = myLoginState.user!.id;
//               final username = _nameController.text;
//               final avatar = _avatarController.text;

//               // Enviar el evento al Bloc
//               context.read<AuthBloc>().add(
//                     UpdateUserInfoUseCase(
//                       userId: userid,
//                       username: username,
//                       avatar: avatar,
//                     ),
//                   );

//               Navigator.of(context).pop(); // Cerrar el diálogo
//             }
//           },
//           child: const Text('Guardar'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _avatarController.dispose();
//     super.dispose();
//   }
// }
