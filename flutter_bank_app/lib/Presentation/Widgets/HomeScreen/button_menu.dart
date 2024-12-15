import 'package:flutter/material.dart';

class ButtonsMenu extends StatelessWidget {
  const ButtonsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          CircleButton(desc: "Área pix", icone: Icons.pix),
          CircleButton(desc: "Pagar", icone: Icons.view_column),
          CircleButton(
            desc: "Transferir",
            icone: Icons.send_to_mobile,
          ),
          CircleButton(desc: "Depositar", icone: Icons.install_mobile),
          CircleButton(
            desc: "Empréstimo",
            icone: Icons.business_center,
          ),
          CircleButton(
            desc: "Seguro",
            icone: Icons.beach_access,
          ),
        ],
      ),
    );
  }
}

class CircleButton extends StatelessWidget {
  final String? desc;
  final IconData? icone;

  const CircleButton({Key? key, this.desc, this.icone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: const Color(0xFF5B0DA8),
            onPressed: () {},
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            tooltip: desc,
            child: Icon(icone),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(desc!,
              style: const TextStyle(fontSize: 16.0, color: Color(0xFF020202))),
        ),
      ],
    );
  }
}
