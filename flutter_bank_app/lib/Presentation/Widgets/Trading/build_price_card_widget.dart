import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildPriceCard(String label, double price, NumberFormat formatter) {
  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(formatter.format(price),
              style: const TextStyle(fontSize: 16, color: Colors.blueAccent)),
        ],
      ),
    ),
  );
}
