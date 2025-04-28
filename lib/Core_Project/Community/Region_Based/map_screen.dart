// ignore_for_file: deprecated_member_use
import 'package:competitivecodingarena/API_KEYS/api.dart';
import 'package:competitivecodingarena/Core_Project/Community/Region_Based/map_data.dart';
import 'package:competitivecodingarena/Messaging/messages_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geocode/geocode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:math' as math;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class ProgrammerInfo {
  final String name;
  final String specialty;
  final LatLng location;
  final String profileImageUrl;

  ProgrammerInfo({
    required this.name,
    required this.specialty,
    required this.location,
    required this.profileImageUrl,
  });
}

class _MapScreenState extends State<MapScreen>
    with SingleTickerProviderStateMixin {
  LatLng? currentLocation;
  String? currentAddress;
  final MapController mapController = MapController();
  final tileProvider = CancellableNetworkTileProvider();
  final GeoCode geoCode = GeoCode(apiKey: ApiKeys().geocodeApi);
  double _currentZoom = 15.0;
  final String _thunderforestApiKey = ApiKeys().thunderforestApiKey;
  String _currentLayer = 'standard';
  double _radiusInMeters = 500.0;
  bool _showRadiusControl = false;
  final bool _showRadius = true;
  late AnimationController _animationController;
  Animation<double>? _zoomAnimation;
  Animation<double>? _latAnimation;
  Animation<double>? _lngAnimation;
  final Duration _animationDuration = const Duration(milliseconds: 500);
  final Curve _animationCurve = Curves.easeInOut;
  bool _isLoadingLocation = false;
  final Duration _cacheDuration = const Duration(minutes: 5);
  final String _locationCacheKey = 'cached_location';
  final String _addressCacheKey = 'cached_address';
  final String _locationTimestampKey = 'location_timestamp';
  bool _showLayerSelector = false;
  bool _showProgrammers = false;
  bool _loadingProgrammers = false;
  List<ProgrammerInfo> _nearbyProgrammers = [];
  final double _minProgrammerDistance = 5.0;
  final double _maxProgrammerDistance = 10.0;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    _loadCachedLocationAndGetCurrent();
  }

  @override
  void dispose() {
    _animationController.stop();
    _animationController.dispose();
    tileProvider.dispose();
    super.dispose();
  }

  Future<void> _loadCachedLocationAndGetCurrent() async {
    if (mounted) {
      setState(() {
        _isLoadingLocation = true;
      });
      bool usedCache = await _loadCachedLocation();
      if (!usedCache) {
        await getCurrentLocation();
      } else {
        setState(() {
          _isLoadingLocation = false;
        });
        _updateLocationInBackground();
      }
    }
  }

  Future<bool> _loadCachedLocation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationJson = prefs.getString(_locationCacheKey);
      final addressData = prefs.getString(_addressCacheKey);
      final timestamp = prefs.getInt(_locationTimestampKey);

      if (locationJson != null && addressData != null && timestamp != null) {
        final cachedTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        final now = DateTime.now();
        if (now.difference(cachedTime) <= _cacheDuration) {
          final locationMap = json.decode(locationJson);
          final location =
              LatLng(locationMap['latitude'], locationMap['longitude']);

          if (mounted) {
            setState(() {
              currentLocation = location;
              currentAddress = addressData;
            });
            _animatedMove(location, _currentZoom);
          }
          return true;
        }
      }
    } catch (e) {
      debugPrint('Error loading cached location: $e');
    }
    return false;
  }

  Future<void> _cacheLocationData() async {
    if (currentLocation != null && currentAddress != null) {
      try {
        final prefs = await SharedPreferences.getInstance();
        final locationMap = {
          'latitude': currentLocation!.latitude,
          'longitude': currentLocation!.longitude,
        };
        await prefs.setString(_locationCacheKey, json.encode(locationMap));
        await prefs.setString(_addressCacheKey, currentAddress!);
        await prefs.setInt(
            _locationTimestampKey, DateTime.now().millisecondsSinceEpoch);
      } catch (e) {
        debugPrint('Error caching location data: $e');
      }
    }
  }

  Future<void> _updateLocationInBackground() async {
    try {
      if (!mounted) return;
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      if (!mounted) return;
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;
      final newLocation = LatLng(position.latitude, position.longitude);
      if (!mounted) return;
      await getAddressFromCoordinates(newLocation);
      if (!mounted) return;
      setState(() {
        currentLocation = newLocation;
      });
      if (!mounted) return;
      await _cacheLocationData();
    } catch (e) {
      debugPrint('Error updating location in background: $e');
    }
  }

  Future<void> getAddressFromCoordinates(LatLng position) async {
    if (!mounted) return;
    try {
      Address address = await geoCode.reverseGeocoding(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (!mounted) return;
      setState(() {
        currentAddress = [
          address.streetAddress,
          address.city,
          address.region,
          address.postal,
          address.countryName,
          position.latitude.toStringAsFixed(2),
          position.longitude.toStringAsFixed(2)
        ].where((element) => element != null).join(', ');
      });
    } catch (e) {
      debugPrint('Error getting address: $e');
    }
  }

  Future<void> getCurrentLocation() async {
    if (!mounted) return;
    setState(() {
      _isLoadingLocation = true;
    });
    LocationPermission permission = await Geolocator.checkPermission();
    if (!mounted) return;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return;
      if (permission == LocationPermission.denied) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;
      final newLocation = LatLng(position.latitude, position.longitude);
      setState(() {
        currentLocation = newLocation;
      });
      await getAddressFromCoordinates(newLocation);
      if (!mounted) return;
      _animatedMove(currentLocation!, _currentZoom);
      if (!mounted) return;
      await _cacheLocationData();
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
      if (!mounted) return;
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _animatedMove(LatLng target, double zoom) {
    if (!mounted) return;
    final startLatLng = mapController.camera.center;
    _latAnimation =
        Tween<double>(begin: startLatLng.latitude, end: target.latitude)
            .animate(CurvedAnimation(
                parent: _animationController, curve: _animationCurve));
    _lngAnimation =
        Tween<double>(begin: startLatLng.longitude, end: target.longitude)
            .animate(CurvedAnimation(
                parent: _animationController, curve: _animationCurve));
    _zoomAnimation = Tween<double>(begin: _currentZoom, end: zoom).animate(
        CurvedAnimation(parent: _animationController, curve: _animationCurve));
    Animation<double> animation =
        CurvedAnimation(parent: _animationController, curve: _animationCurve);
    void listener() {
      if (mounted) {
        mapController.move(LatLng(_latAnimation!.value, _lngAnimation!.value),
            _zoomAnimation!.value);
      }
    }

    animation.addListener(listener);
    _animationController.forward(from: 0).then((_) {
      if (mounted) {
        setState(() => _currentZoom = zoom);
        animation.removeListener(listener);
      }
    });
  }

  TileLayer get _tileLayer {
    final layer = mapLayers[_currentLayer]!;
    String url = layer.requiresApiKey
        ? layer.urlTemplate.replaceAll('{apikey}', _thunderforestApiKey)
        : layer.urlTemplate;
    return TileLayer(
        urlTemplate: url,
        userAgentPackageName: 'com.example.app',
        tileProvider: tileProvider,
        maxZoom: 19,
        keepBuffer: 5);
  }

  void _toggleRadiusControl() {
    if (mounted) setState(() => _showRadiusControl = !_showRadiusControl);
  }

  void _toggleLayerSelector() {
    if (mounted) setState(() => _showLayerSelector = !_showLayerSelector);
  }

  void _changeMapLayer(String layerKey) {
    if (mounted) {
      setState(() {
        _currentLayer = layerKey;
        _showLayerSelector = false;
      });
    }
  }

  Future<void> _forceRefreshLocation() async {
    await getCurrentLocation();
    // If programmers are being shown, refresh them too
    if (_showProgrammers) {
      await _fetchNearbyProgrammers();
    }
  }

  // Method to toggle showing programmers
  void _toggleShowProgrammers() async {
    if (!_showProgrammers && currentLocation != null) {
      await _fetchNearbyProgrammers();
    }

    if (mounted) {
      setState(() {
        _showProgrammers = !_showProgrammers;
      });
    }
  }

  // Method to fetch nearby programmers within 10-50 meter radius
  Future<void> _fetchNearbyProgrammers() async {
    if (currentLocation == null) return;

    if (mounted) {
      setState(() {
        _loadingProgrammers = true;
      });
    }

    try {
      await Future.delayed(const Duration(seconds: 1));
      final random = math.Random();
      List<ProgrammerInfo> programmers = [];
      final names = ['Devang Mane'];
      double radius = _minProgrammerDistance +
          random.nextDouble() *
              (_maxProgrammerDistance - _minProgrammerDistance);
      double angle = random.nextDouble() * 2 * math.pi;
      const earthRadius = 6378137.0;
      double radiusDegrees = radius / (earthRadius * math.pi / 180);
      double lat = currentLocation!.latitude + radiusDegrees * math.cos(angle);
      double lng = currentLocation!.longitude +
          radiusDegrees *
              math.sin(angle) /
              math.cos(currentLocation!.latitude * math.pi / 180);
      programmers.add(
        ProgrammerInfo(
          name:
              '${names[random.nextInt(names.length)]} ${(65 + random.nextInt(26)).toRadixString(36).toUpperCase()}.',
          specialty: 'Android',
          location: LatLng(lat, lng),
          // Using a placeholder image URL
          profileImageUrl: 'https://via.placeholder.com/150',
        ),
      );

      if (mounted) {
        setState(() {
          _nearbyProgrammers = programmers;
          _loadingProgrammers = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching nearby programmers: $e');
      if (mounted) {
        setState(() {
          _loadingProgrammers = false;
        });
      }
    }
  }

  // When zooming in to see the nearby programmers
  void _zoomToShowProgrammers() {
    if (currentLocation != null) {
      // Zoom level 18 is good for seeing objects within ~50m radius
      _animatedMove(currentLocation!, 18.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter:
                currentLocation ?? const LatLng(51.509364, -0.128928),
            initialZoom: _currentZoom,
          ),
          children: [
            _tileLayer,
            if (currentLocation != null) ...[
              if (_showRadius)
                MapRadiusOverlay(
                    radius: _radiusInMeters, location: currentLocation!),
              MapMarker(
                  location: currentLocation!, onTap: _toggleRadiusControl),

              // Show programmer markers when enabled
              if (_showProgrammers && _nearbyProgrammers.isNotEmpty)
                MarkerLayer(
                  markers: _nearbyProgrammers.map((programmer) {
                    return Marker(
                      point: programmer.location,
                      width: 40,
                      height: 40,
                      child: GestureDetector(
                        onTap: () {
                          // Show programmer info when tapped
                          _showProgrammerInfo(programmer);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.8),
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.white),
                          ),
                          child: Icon(
                            Icons.code,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
            MapAttribution(),
          ],
        ),
      ),
      if (_showRadiusControl)
        Positioned(
          bottom: 0,
          child: RadiusControl(
              minRadius: 0,
              maxRadius: 1000,
              radius: _radiusInMeters,
              onChanged: (value) {
                if (mounted) setState(() => _radiusInMeters = value);
              }),
        ),
      // Enhanced map controls
      Positioned(
        right: 16,
        bottom: 16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'zoomIn',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () =>
                  _animatedMove(mapController.camera.center, _currentZoom + 1),
              child: const Icon(Icons.add, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'zoomOut',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () =>
                  _animatedMove(mapController.camera.center, _currentZoom - 1),
              child: const Icon(Icons.remove, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'layers',
              mini: true,
              backgroundColor: Colors.white,
              onPressed: _toggleLayerSelector,
              child: const Icon(Icons.layers, color: Colors.blue),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'programmers',
              mini: true,
              backgroundColor: _showProgrammers ? Colors.green : Colors.white,
              onPressed: () {
                _toggleShowProgrammers();
                if (!_showProgrammers) {
                  // If we're turning programmers on, zoom in to see them better
                  _zoomToShowProgrammers();
                }
              },
              child: Icon(
                Icons.people,
                color: _showProgrammers ? Colors.white : Colors.blue,
              ),
            ),
            const SizedBox(height: 8),
            FloatingActionButton(
              heroTag: 'location',
              backgroundColor: Colors.blue,
              onPressed: _forceRefreshLocation,
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
          ],
        ),
      ),
      // Layer selector
      if (_showLayerSelector)
        Positioned(
            right: 70,
            bottom: 16,
            child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: mapLayers.entries.map((entry) {
                          return SizedBox(
                              height: 40,
                              width: 400,
                              child: ListTile(
                                  leading: Icon(entry.value.icon,
                                      color: _currentLayer == entry.key
                                          ? Colors.blue
                                          : Colors.grey),
                                  title: Text(entry.value.name),
                                  selected: _currentLayer == entry.key,
                                  selectedTileColor:
                                      Colors.blue.withOpacity(0.1),
                                  dense: true,
                                  onTap: () => _changeMapLayer(entry.key)));
                        }).toList())))),
      if (currentAddress != null && !_isLoadingLocation)
        Positioned(
            top: 16,
            left: 30,
            right: 30,
            child: Container(
                constraints:
                    BoxConstraints(minWidth: 0, maxWidth: double.infinity),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(currentAddress!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center))),
      // Add loading indicator
      if (_isLoadingLocation)
        Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
                child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2))
                  ]),
              child: Row(mainAxisSize: MainAxisSize.min, children: const [
                SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.blue))),
                SizedBox(width: 12),
                Text("Getting location...",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))
              ]),
            ))),
      // Loading programmers indicator
      if (_loadingProgrammers)
        Positioned(
          bottom: 80,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    "Finding programmers nearby...",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
      // Programmer count badge when they're visible
      if (_showProgrammers && _nearbyProgrammers.isNotEmpty)
        Positioned(
          right: 16,
          top: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.people, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  "${_nearbyProgrammers.length} nearby",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
    ]);
  }

  void _showProgrammerInfo(ProgrammerInfo programmer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green.shade600,
              radius: 24,
              child: Icon(Icons.code, color: Colors.white, size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    programmer.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    programmer.specialty,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 0,
                color: Colors.blue.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, color: Colors.red.shade600),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Distance",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              _calculateDistance(programmer.location) + " away",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "About",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "Hey there, I'm a Competitive Programmer",
                style: TextStyle(height: 1.4),
              ),
              Divider(height: 24),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.amber.shade700),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Connect with ${programmer.name.split(' ')[0]} to collaborate on coding projects!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey.shade700,
            ),
            child: Text("CANCEL"),
          ),
          ElevatedButton.icon(
            onPressed: () {
              PushNotification.sendNotification(token: "", title: "", body: "");
              Navigator.of(context).pop();
              _showConnectSuccess(programmer);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.person_add, size: 18),
            label: Text("CONNECT"),
          ),
        ],
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  String _calculateDistance(LatLng programmerLocation) {
    if (currentLocation == null) return "Unknown";

    // Calculate distance between current location and programmer location
    double distanceInMeters = Geolocator.distanceBetween(
      currentLocation!.latitude,
      currentLocation!.longitude,
      programmerLocation.latitude,
      programmerLocation.longitude,
    );

    // Format the distance
    if (distanceInMeters < 1000) {
      return "${distanceInMeters.round()} meters";
    } else {
      return "${(distanceInMeters / 1000).toStringAsFixed(1)} km";
    }
  }

  void _showConnectSuccess(ProgrammerInfo programmer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Connection request sent to ${programmer.name}"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: "UNDO",
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Connection request canceled"),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
