import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
class MapScreen extends StatefulWidget {

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _addressController = TextEditingController();
  List<Marker> _markers = [];
  List<Map<String, dynamic>> _nearbyCenters = [];
  String apiKey = "245734cfe33f471babf2e0af28b97350"; // Replace with OpenCage API key
  Position? _currentPosition;
  List<LatLng> _routePoints = [];
  LatLng? _selectedDestination;
  LatLng? _routeStart;
  String _phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // Get user's current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showLocationDialog(
          "Location services are disabled. Please enable them in settings.");
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showLocationDialog(
            "Location permission is required to fetch your current location.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showLocationDialog(
          "Location permissions are permanently denied. Please enable them manually in settings.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    if (!mounted) return; // Prevents setState after dispose

    setState(() {
      _currentPosition = position;
      _routeStart = LatLng(position.latitude, position.longitude);
    });

    _loadNearbyEWasteCenters(position.latitude, position.longitude);
  }

  // Show an alert dialog when location is disabled
  void _showLocationDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Location Required"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to handle location search and place a blue marker
  Future<void> _searchLocation() async {
    String address = _addressController.text.trim();
    if (address.isEmpty) return;

    var coordinates = await _getCoordinates(address);
    if (coordinates != null) {
      print("Coordinates for $address: ${coordinates[0]}, ${coordinates[1]}");

      LatLng newLocation = LatLng(coordinates[0], coordinates[1]);

      // Move the map to the searched location
      _mapController.move(newLocation, 12);

      // Update state with the new marker
      setState(() {
        _markers.clear(); // Clear previous markers

        

        // Add Black Marker at searched location
        _markers.add(
          Marker(
            point: newLocation,
            width: 50.0,
            height: 50.0,
            child: const Icon(
              Icons.location_on,
              color: Colors.black, // Black marker
              size: 30.0,
            ),
          ),
        );
      });

      // Update the start point for routing
      _routeStart = newLocation;

      // Load nearby e-waste centers
      _loadNearbyEWasteCenters(coordinates[0], coordinates[1]);
    } else {
      print("No coordinates found for the entered address.");
    }
  }

  // Fetch coordinates using OpenCage API
  Future<List<double>?> _getCoordinates(String address) async {
    final url = 'https://api.opencagedata.com/geocode/v1/json?q=${Uri
        .encodeComponent(address)}&key=$apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final lat = data['results'][0]['geometry']['lat'];
        final lng = data['results'][0]['geometry']['lng'];
        return [lat, lng];
      }
    }
    return null;
  }

  // Load e-waste centers and filter those within 10 km
  Future<void> _loadNearbyEWasteCenters(double userLat, double userLon) async {
    final String response = await rootBundle.loadString('assets/ewaste.json');
    final List<dynamic> data = json.decode(response);

    List<Marker> markers = [];
    List<Map<String, dynamic>> nearbyCenters = [];

    for (var center in data) {
      double? lat = center["Latitude"];
      double? lon = center["Longitude"];

      if (lat != null && lon != null) {
        double distance = _calculateDistance(userLat, userLon, lat, lon);

        if (distance <= 10) { // Within 10 km
          nearbyCenters.add(center);
          markers.add(
            Marker(
              point: LatLng(lat, lon),
              width: 30.0,
              height: 30.0,
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 30.0,
              ),
            ),
          );
        }
      }
    }

    setState(() {
      _markers = markers;
      _nearbyCenters = nearbyCenters;
    });
  }

  // Calculate distance using Haversine formula
  double _calculateDistance(double lat1, double lon1, double lat2,
      double lon2) {
    const double R = 6371; // Radius of Earth in km
    double dLat = _degToRad(lat2 - lat1);
    double dLon = _degToRad(lon2 - lon1);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degToRad(lat1)) * cos(_degToRad(lat2)) * sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _degToRad(double deg) {
    return deg * (pi / 180);
  }

  // Fetch route from current location to selected center using OSRM API
  Future<void> _getRoute(LatLng destination) async {
    if (_routeStart != null && _selectedDestination != null) {
      final String url = 'https://router.project-osrm.org/route/v1/driving/'
          '${_routeStart!.longitude},${_routeStart!.latitude};'
          '${destination.longitude},${destination
          .latitude}?overview=full&geometries=geojson';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'];
          final List<dynamic> coordinates = geometry['coordinates'];
          List<LatLng> routePoints = coordinates
              .map((coord) => LatLng(coord[1], coord[0]))
              .toList();

          setState(() {
            _routePoints = routePoints;
          });
        }
      } else {
        print('Failed to fetch route');
      }
    }
  }


  // Function to handle phone number click and show dialog for Chat or Call
  void _showPhoneNumberDialog(String phoneNumber) {
    setState(() {
      _phoneNumber = phoneNumber;
    });

    // Show dialog with options
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose an Option"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Would you like to chat or call?"),
                SizedBox(height: 10),
                Text(
                  "Phone Number: $phoneNumber",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => _launchSMS(phoneNumber),
              child: Text("Chat"),
            ),
            TextButton(
              onPressed: () => _launchPhoneDialer(phoneNumber),
              child: Text("Call"),
            ),
          ],
        );
      },
    );
  }


  // Function to launch WhatsApp chat

  void _launchSMS(String phoneNumber) async {
    final url = 'sms:$phoneNumber'; // Using 'sms:' to open the SMS app
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not open SMS app';
      }
    } catch (e) {
      print('Error launching SMS: $e');
    }
  }

  // Function to launch phone dialer
  void _launchPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not open phone dialer';
    }
  }

  // Function to show the phone number dialog
  void _showPhoneNumber(String phoneNumber) {
    _showPhoneNumberDialog(phoneNumber);
  }

  @override // Import Google Fonts

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "E-Waste Centers in Tamil Nadu",
          style: GoogleFonts.poppins(color: Colors.white), // Apply Poppins font
        ),
        backgroundColor: Colors.black, // Dark background for the AppBar
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addressController,
                    style: GoogleFonts.poppins(color: Colors.white),
                    // Apply Poppins font
                    decoration: InputDecoration(
                      hintText: "Enter a location",
                      hintStyle: TextStyle(color: Colors.grey),
                      // Grey hint text
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // White border for TextField
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      filled: true,
                      fillColor: Colors
                          .black54, // Dark background color for TextField
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search, color: Colors.blue),
                  onPressed: _searchLocation,
                ),
                IconButton(
                  icon: Icon(Icons.my_location, color: Colors.green),
                  onPressed: _getCurrentLocation,
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(11.1271, 78.6569),
                initialZoom: 7,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(markers: _markers),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: 4.0,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
          _nearbyCenters.isNotEmpty
              ? Expanded(
            child: ListView.builder(
              itemCount: _nearbyCenters.length,
              itemBuilder: (context, index) {
                var center = _nearbyCenters[index];
                return ListTile(
                  leading: Icon(Icons.recycling, color: Colors.green),
                  title: Text(
                    center["Name"],
                    style: GoogleFonts.poppins( // Apply Poppins font
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // White text for ListTile title
                    ),
                  ),
                  subtitle: Text(
                    center["Address"],
                    style: GoogleFonts.poppins(
                        color: Colors.grey), // Apply Poppins font
                  ),
                  tileColor: Colors.black54,
                  // Black background for ListTile
                  onTap: () {
                    double lat = center["Latitude"];
                    double lon = center["Longitude"];
                    _selectedDestination = LatLng(lat, lon);
                    _getRoute(_selectedDestination!);

                    // Add a green marker for the selected e-waste center
                    setState(() {
                      _markers.add(
                        Marker(
                          point: LatLng(lat, lon),
                          width: 30.0,
                          height: 30.0,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 30.0,
                          ),
                        ),
                      );
                    });
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.phone, color: Colors.white), // White phone icon
                        onPressed: () => _showPhoneNumber(center["PhoneNumber"]),
                      ),


                    ],
                  ),

                );
              },
            ),
          )
              : Center(child: CircularProgressIndicator()),
        ],
      ),
      backgroundColor: Colors.black, // Black background for the whole screen
    );
  }
}
