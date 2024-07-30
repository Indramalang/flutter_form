import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, double>> getCoordinates(String location) async {
  final query = Uri.encodeComponent(location);
  final url =
      'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    if (data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);
      return {'latitude': lat, 'longitude': lon};
    }
  }

  throw Exception('Failed to get coordinates');
}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? center;
  TextEditingController _controller = TextEditingController();

  Future<void> _searchLocation() async {
    final location = _controller.text;
    try {
      final coordinates = await getCoordinates(location);
      setState(() {
        center = LatLng(coordinates['latitude']!, coordinates['longitude']!);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peta'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Masukkan lokasi',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
              ],
            ),
          ),
          Expanded(
            child: center == null
                ? Center(child: Text('Masukkan lokasi untuk mencari'))
                : FlutterMap(
                    key: ValueKey(center), // Key to force rerender
                    options: MapOptions(
                      center: center,
                      zoom: 14.0,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                        subdomains: ['a', 'b', 'c'],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
