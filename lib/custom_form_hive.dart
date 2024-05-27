import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'display_form.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _controllernama = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LinkedHashMap<int, String> data = LinkedHashMap<int, String>();
  LinkedHashMap<int, bool> _isChecked = LinkedHashMap<int, bool>();
  late Box box;
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _bacaData();
  }

  void _bacaData() async {
    box = await Hive.openBox('myBox');
    final savedData = box.get('data', defaultValue: {});
    final savedIsChecked = box.get('isChecked', defaultValue: {});

    setState(() {
      data = LinkedHashMap<int, String>.from(savedData);
      _isChecked = LinkedHashMap<int, bool>.from(savedIsChecked);
      _counter = data.keys.isNotEmpty ? data.keys.reduce(max) + 1 : 0;
    });
  }

  void _tambahData(String nama, bool isChecked) {
    setState(() {
      data[_counter] = nama;
      _isChecked[_counter] = isChecked;
      _counter++;
    });
    _simpanData();
    _simpanData_cheked();
  }

  void _hapusData() {
    if (data.isNotEmpty) {
      setState(() {
        int firstKey = data.keys.first;
        data.remove(firstKey);
        _isChecked.remove(firstKey);
      });
      _simpanData();
      _simpanData_cheked();
    }
  }

  void _simpanData() async {
    box.put('data', data);
  }

  void _simpanData_cheked() async {
    box.put('isChecked', _isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 60.0, // Atur tinggi sesuai kebutuhan Anda
              color: Colors.blue,
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Menu Navigasi',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
            ListTile(
              title: Text('Data Todo List'),
              onTap: () {
                _bacaData();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataDisplayPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            left: 75,
            child: SizedBox(
              width: 200,
              height: 200,
              child: Image(
                image: AssetImage("assets/images/gambarlaptop.jpg"),
                width: 300,
                height: 300,
              ),
            ),
          ),
          Positioned(
            top: 220,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Container(
                  width: 300.0,
                  height: 500.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Masukan Input Todo List',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextFormField(
                        controller: _controllernama,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Anda harus memasukan input';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _tambahData(_controllernama.text, false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Data Diproses')),
                              );
                              _controllernama.clear();
                            }
                          },
                          child: Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
