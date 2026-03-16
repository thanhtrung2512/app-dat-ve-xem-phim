import 'package:flutter/material.dart';

class CinemaScreen extends StatelessWidget {
  const CinemaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hệ thống Rạp"),
        backgroundColor: const Color(0xFFE51937),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ListTile(
            title: Text("TT Cinema Hà Đông"),
            subtitle: Text("Mở cửa: 08:30 - 23:30"),
            leading: Icon(Icons.location_on, color: Color(0xFFE51937)),
          ),
          ListTile(
            title: Text("TT Cinema Cầu Giấy"),
            subtitle: Text("Mở cửa: 09:00 - 23:00"),
            leading: Icon(Icons.location_on, color: Color(0xFFE51937)),
          ),
          ListTile(
            title: Text("TT Cinema Gò Vấp"),
            subtitle: Text("Mở cửa: 08:00 - 00:00"),
            leading: Icon(Icons.location_on, color: Color(0xFFE51937)),
          ),
        ],
      ),
    );
  }
}
