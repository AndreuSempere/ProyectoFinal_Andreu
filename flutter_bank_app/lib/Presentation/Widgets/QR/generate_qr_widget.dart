class GenerateQrPage extends StatelessWidget {
  final String accountId;

  GenerateQrPage({required this.accountId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Generar QR")),
      body: Center(
        child: QrImage(
          data: accountId, // Aquí usas el accountId del usuario
          size: 200,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
