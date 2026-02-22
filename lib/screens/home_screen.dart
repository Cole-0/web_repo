import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; //
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ip_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ipController = TextEditingController();
  Map<String, dynamic>? _geoData;
  List<String> _history = [];
  bool _isLoading = false;

  // Selection and Map state
  final Set<String> _selectedItems = {};
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // Updates the map position and pin
  void _updateMap(double lat, double lng) {
    final position = LatLng(lat, lng);
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('searchedLocation'),
          position: position,
          infoWindow: InfoWindow(title: _geoData?['ip'] ?? "Location"),
        ),
      };
    });
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(position, 12));
  }

  // Helper to parse "lat,lng" string from API
  void _handleCoordinates(String? loc) {
    if (loc != null && loc.contains(',')) {
      final parts = loc.split(',');
      final lat = double.tryParse(parts[0]);
      final lng = double.tryParse(parts[1]);
      if (lat != null && lng != null) {
        _updateMap(lat, lng);
      }
    }
  }

  void _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      final data = await IpService.fetchIpDetails();
      setState(() {
        _geoData = data;
        _handleCoordinates(data['loc']);
      });
    } catch (e) {
      _showError("Could not fetch your IP info");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false); // Clear the session

    if (!mounted) return;
    // Go back to Login and clear the navigation history
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false
    );
  }

  void _searchIp(String ip) async {
    final ipRegex = RegExp(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$");
    if (!ipRegex.hasMatch(ip)) {
      _showError("Please enter a valid IP address");
      return;
    }

    setState(() => _isLoading = true);
    try {
      final data = await IpService.fetchIpDetails(ip);
      setState(() {
        _geoData = data;
        if (!_history.contains(ip)) _history.insert(0, ip);
        _handleCoordinates(data['loc']);
      });
    } catch (e) {
      _showError("IP not found or invalid");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _deleteSelected() {
    setState(() {
      _history.removeWhere((ip) => _selectedItems.contains(ip));
      _selectedItems.clear();
    });
    _showError("Selected history deleted");
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home - IP Geo"),
        actions: [
          if (_selectedItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteSelected,
            ),
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: InputDecoration(
                hintText: "Enter IP Address",
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () => _searchIp(_ipController.text),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _ipController.clear();
                _loadInitialData();
              },
              child: const Text("Clear Search"),
            ),

            // Map Display

            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: GoogleMap(
                  initialCameraPosition: const CameraPosition(target: LatLng(0, 0), zoom: 2),
                  onMapCreated: (controller) => _mapController = controller,
                  markers: _markers,
                ),
              ),
            ),

            const SizedBox(height: 10),
            if (_isLoading) const LinearProgressIndicator(),

            if (_geoData != null) Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.blue),
                title: Text("IP: ${_geoData!['ip']}"),
                subtitle: Text("${_geoData!['city']}, ${_geoData!['region']}, ${_geoData!['country']}"),
              ),
            ),

            const Divider(),
            const Text("Search History", style: TextStyle(fontWeight: FontWeight.bold)),

            Expanded(
              child: ListView.builder(
                itemCount: _history.length,
                itemBuilder: (context, index) {
                  final ip = _history[index];
                  return CheckboxListTile(
                    title: Text(ip),
                    value: _selectedItems.contains(ip),
                    onChanged: (bool? selected) {
                      setState(() {
                        selected == true ? _selectedItems.add(ip) : _selectedItems.remove(ip);
                      });
                    },
                    secondary: IconButton(
                      icon: const Icon(Icons.refresh),
                      onPressed: () => _searchIp(ip),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}