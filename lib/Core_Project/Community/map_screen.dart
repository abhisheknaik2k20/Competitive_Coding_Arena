// ignore_for_file: deprecated_member_use
import 'package:competitivecodingarena/API_KEYS/api.dart';
import 'package:competitivecodingarena/Core_Project/Community/map_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:geocode/geocode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
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

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    _loadCachedLocationAndGetCurrent();
  }

  @override
  void dispose() {
    _animationController.dispose();
    tileProvider.dispose();
    super.dispose();
  }

  Future<void> _loadCachedLocationAndGetCurrent() async {
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
          setState(() {
            currentLocation = location;
            currentAddress = addressData;
          });
          if (mounted) {
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
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;
      final newLocation = LatLng(position.latitude, position.longitude);
      await getAddressFromCoordinates(newLocation);
      setState(() {
        currentLocation = newLocation;
      });
      await _cacheLocationData();
    } catch (e) {
      debugPrint('Error updating location in background: $e');
    }
  }

  Future<void> getAddressFromCoordinates(LatLng position) async {
    try {
      Address address = await geoCode.reverseGeocoding(
        latitude: position.latitude,
        longitude: position.longitude,
      );

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
    setState(() {
      _isLoadingLocation = true;
    });

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
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
      _animatedMove(currentLocation!, _currentZoom);
      await _cacheLocationData();

      setState(() {
        _isLoadingLocation = false;
      });
    } catch (e) {
      debugPrint('Error getting location: $e');
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _animatedMove(LatLng target, double zoom) {
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
    animation.addListener(() {
      mapController.move(LatLng(_latAnimation!.value, _lngAnimation!.value),
          _zoomAnimation!.value);
    });
    _animationController
        .forward(from: 0)
        .then((_) => setState(() => _currentZoom = zoom));
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

  void _toggleRadiusControl() =>
      setState(() => _showRadiusControl = !_showRadiusControl);

  void _toggleLayerSelector() =>
      setState(() => _showLayerSelector = !_showLayerSelector);

  void _changeMapLayer(String layerKey) {
    setState(() {
      _currentLayer = layerKey;
      _showLayerSelector = false;
    });
  }

  Future<void> _forceRefreshLocation() async {
    await getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
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
                onChanged: (value) => setState(() => _radiusInMeters = value)),
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
                onPressed: () => _animatedMove(
                    mapController.camera.center, _currentZoom + 1),
                child: const Icon(Icons.add, color: Colors.blue),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'zoomOut',
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () => _animatedMove(
                    mapController.camera.center, _currentZoom - 1),
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
                        selectedTileColor: Colors.blue.withOpacity(0.1),
                        dense: true,
                        onTap: () => _changeMapLayer(entry.key),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
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
              child: Text(
                currentAddress!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        // Add loading indicator
        if (_isLoadingLocation)
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Getting location...",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Attribution dialog button
      ],
    );
  }
}
