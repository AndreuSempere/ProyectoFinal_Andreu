import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar(
      {super.key,
      required String appBarTitle,
      required IconData leadingIcon,
      required BuildContext context})
      : super(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            appBarTitle,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 14.0,
                fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(
              leadingIcon,
              color: Colors.black,
              size: 15.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
}
