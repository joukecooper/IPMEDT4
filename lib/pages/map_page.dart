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
  int routeId = 1;
  final MapController mapController = MapController();
  String? currentUserID;

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
      mapController.move(points.first, 12.5);
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
          Uri.parse('http://dsf-server.nl/api/user/$currentUserID/coins'),
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
            DataTable(
              showCheckboxColumn: false,
              columns: const <DataColumn>[
                DataColumn(
                  label: Text('Route'),
                ),
                DataColumn(
                  label: Text('KM'),
                ),
                DataColumn(
                  label: Text('Duur'),
                ),
                DataColumn(
                  label: Text('Munten'),
                ),
              ],
              rows: [
                DataRow(
                  selected: selectedRoute == 'Route 1',
                  cells: const <DataCell>[
                    DataCell(Text('Route-1')),
                    DataCell(Text('4.5')),
                    DataCell(Text('1 u')),
                    DataCell(Text('10')),
                  ],
                  onSelectChanged: (selected) {
                    setState(() {
                      selectedRoute = 'Route 1';
                      routeId = 1;
                    });
                    loadGpxData('Route 1');
                  },
                  color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) return Colors.lightGreen.withOpacity(0.2);
                    return null;
                  }),
                ),
                DataRow(
                  selected: selectedRoute == 'Route 2',
                  cells: const <DataCell>[
                    DataCell(Text('Route-2')),
                    DataCell(Text('9')),
                    DataCell(Text('2 u')),
                    DataCell(Text('25')),
                  ],
                  onSelectChanged: (selected) {
                    setState(() {
                      selectedRoute = 'Route 2';
                      routeId = 2;
                    });
                    loadGpxData('Route 2');
                  },
                  color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) return Colors.lightGreen.withOpacity(0.2);
                    return null;
                  }),
                ),
                DataRow(
                  selected: selectedRoute == 'Route 3',
                  cells: const <DataCell>[
                    DataCell(Text('Route-3')),
                    DataCell(Text('13.5')),
                    DataCell(Text('3 u')),
                    DataCell(Text('40')),
                  ],
                  onSelectChanged: (selected) {
                    setState(() {
                      selectedRoute = 'Route 3';
                      routeId = 3;
                    });
                    loadGpxData('Route 3');
                  },
                  color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) return Colors.lightGreen.withOpacity(0.2);
                    return null;
                  }),
                ),
                DataRow(
                  selected: selectedRoute == 'Route 4',
                  cells: const <DataCell>[
                    DataCell(Text('Route-4')),
                    DataCell(Text('18')),
                    DataCell(Text('4 u')),
                    DataCell(Text('55')),
                  ],
                  onSelectChanged: (selected) {
                    setState(() {
                      selectedRoute = 'Route 4';
                      routeId = 4;
                    });
                    loadGpxData('Route 4');
                  },
                  color: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                    if (states.contains(MaterialState.selected)) return Colors.lightGreen.withOpacity(0.2);
                    return null;
                  }),
                ),
              ],
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
                    child: FilledButton(
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
