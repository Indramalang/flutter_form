import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'display_form.dart';

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final _controllernama = TextEditingController();
  final _controlleralamat = TextEditingController();

  Future<void> _simpanData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString('nama', _controllernama.text);
      prefs.setString('alamat', _controlleralamat.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 60,
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
                        'Masukan Input Nama',
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
                      Text(
                        'Masukan Input Alamat',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextFormField(
                        controller: _controlleralamat,
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
                              _simpanData();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DataDisplayPage()));
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Data Diproses')));
                            }
                          },
                          child: Text('Submit'),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        )
      ],
    );
  }
}
