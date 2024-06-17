import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Tabel sectie
            DataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text('Route')),
                DataColumn(label: Text('KM')),
                DataColumn(label: Text('Duur')),
                DataColumn(label: Text('Moeilijk')),
                DataColumn(label: Text('Munten')),
              ],
              rows: const <DataRow>[
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text('Route 1')),
                    DataCell(Text('10')),
                    DataCell(Text('1 uur')),
                    DataCell(Text('Makkelijk')),
                    DataCell(Text('100')),
                  ],
                ),
                // Voeg hier meer routes toe
              ],
            ),
            SizedBox(height: 20),
            // Kaart sectie
            Container(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(51.509364, -0.128928),
                  initialZoom: 9.2,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Start knop
            ElevatedButton(
              onPressed: () {
                // Start knop functionaliteit
              },
              child: Text('Start'),
            ),
          ],
        ),
      ),
    );
  }
}
