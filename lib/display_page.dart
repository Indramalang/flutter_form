import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataDisplayPage extends StatefulWidget {
  @override
  _DataDisplayPageState createState() => _DataDisplayPageState();
}

class _DataDisplayPageState extends State<DataDisplayPage> {
  String nama = '';
  String alamat = '';

  void _bacaData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? '';
      alamat = prefs.getString('alamat') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _bacaData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data diproses'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(top: 60, left: 20, child: Text('Data nama: $nama')),
          Positioned(top: 100, left: 20, child: Text('Data alamat:$alamat'))
        ],
      ),
    );
  }
}
