import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'package:gpx/gpx.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/auth_service.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<LatLng> polylinePoints = [];
  String selectedRoute = 'Route 1';
  int routeId = 1; // Default route ID for Route 1
  final MapController mapController = MapController();
  String? currentUserID; // Variabele om de huidige gebruikers-ID op te slaan

  final Map<String, String> routes = {
    'Route 1': 'lib/assets/route1.gpx',
    'Route 2': 'lib/assets/route2.gpx',
    'Route 3': 'lib/assets/route3.gpx',
    'Route 4': 'lib/assets/route4.gpx',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadGpxData('Route 1');
      getCurrentUserID();
    });
  }

  Future<void> getCurrentUserID() async {
    final authService = AuthService();
    final uid = await authService.getCurrentUID();
    setState(() {
      currentUserID = uid;
    });
  }

  Future<void> loadGpxData(String route) async {
    final gpxString = await DefaultAssetBundle.of(context).loadString(routes[route]!);

    final gpx = GpxReader().fromString(gpxString);

    final points = <LatLng>[];
    for (final track in gpx.trks) {
      for (final segment in track.trksegs) {
        for (final point in segment.trkpts) {
          points.add(LatLng(point.lat!, point.lon!));
        }
      }
    }

    setState(() {
      polylinePoints = points;
    });

    if (points.isNotEmpty) {
      await Future.delayed(Duration.zero);
      mapController.move(points.first, 12.5); // Zoom in on the start point of the route
    }

    // Debugging
    print(currentUserID);
    print('Polyline Points for $route: $polylinePoints');
  }

  Future<void> startRoute() async {
    try {
      if (currentUserID == null) {
        throw Exception('User ID is null');
      }

      // Step 1: Fetch coins for the selected route
      final responseCoins = await http.get(Uri.parse('http://dsf-server.nl/api/routes/$routeId/coins'));

      if (responseCoins.statusCode == 200) {
        final coinsData = json.decode(responseCoins.body);
        final int coins = coinsData['coins'];

        // Step 2: Update user coins with PUT request
        final responseUserCoins = await http.put(
          Uri.parse('http://dsf-server.nl/api/user/$currentUserID/coins'), // Gebruik currentUserID in de URL
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, int>{'coins': coins}),
        );

        if (responseUserCoins.statusCode == 200) {
          // Step 3: Display notification
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Goed gedaan! Je hebt $coins munten verdiend.'),
            ),
          );
        } else {
          throw Exception('Failed to update user coins');
        }
      } else {
        throw Exception('Failed to fetch route coins');
      }
    } catch (e) {
      print('Error starting route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      bottomNavigationBar: const Footer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text('Route'),
                      flex: 2,
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('KM'),
                      flex: 1,
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('Duur'),
                      flex: 2,
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text('Munten'),
                      flex: 1,
                    ),
                  ),
                ],
                rows: [
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Text('Route 1'),
                        onTap: () {
                          setState(() {
                            selectedRoute = 'Route 1';
                            routeId = 1; // Set route ID for Route 1
                          });
                          loadGpxData('Route 1');
                        },
                      ),
                      const DataCell(Text('4.5')),
                      const DataCell(Text('1 uur')),
                      const DataCell(Text('10')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Text('Route 2'),
                        onTap: () {
                          setState(() {
                            selectedRoute = 'Route 2';
                            routeId = 2; // Set route ID for Route 2
                          });
                          loadGpxData('Route 2');
                        },
                      ),
                      const DataCell(Text('9')),
                      const DataCell(Text('2 uur')),
                      const DataCell(Text('25')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Text('Route 3'),
                        onTap: () {
                          setState(() {
                            selectedRoute = 'Route 3';
                            routeId = 3; // Set route ID for Route 3
                          });
                          loadGpxData('Route 3');
                        },
                      ),
                      const DataCell(Text('13.5')),
                      const DataCell(Text('3 uur')),
                      const DataCell(Text('40')),
                    ],
                  ),
                  DataRow(
                    cells: <DataCell>[
                      DataCell(
                        Text('Route 4'),
                        onTap: () {
                          setState(() {
                            selectedRoute = 'Route 4';
                            routeId = 4; // Set route ID for Route 4
                          });
                          loadGpxData('Route 4');
                        },
                      ),
                      const DataCell(Text('18')),
                      const DataCell(Text('4 uur')),
                      const DataCell(Text('55')),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Map section
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: LatLng(52.16768410191399, 4.470880492394246),
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        userAgentPackageName: 'com.example.app',
                      ),
                      if (polylinePoints.isNotEmpty)
                        PolylineLayer(
                          polylines: [
                            Polyline(
                              points: polylinePoints,
                              color: Colors.blue,
                              strokeWidth: 4.0,
                            ),
                          ],
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
                  Positioned(
                    bottom: 10,
                    left: 100,
                    right: 100,
                    child: ElevatedButton(
                      onPressed: startRoute,
                      child: const Text('Start route'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
