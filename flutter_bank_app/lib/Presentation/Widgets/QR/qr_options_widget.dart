class QrOptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Opciones QR")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // Generar QR con accountId
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GenerateQrPage(accountId: "usuario_id_123"),
                ),
              );
            },
            child: Text("Generar QR"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Leer QR
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScanQrPage(),
                ),
              );
            },
            child: Text("Leer QR"),
          ),
        ],
      ),
    );
  }
}
