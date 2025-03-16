// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLayerConfig {
  final String name;
  final String urlTemplate;
  final IconData icon;
  final bool requiresApiKey;

  MapLayerConfig({
    required this.name,
    required this.urlTemplate,
    required this.icon,
    this.requiresApiKey = false,
  });
}

final Map<String, MapLayerConfig> mapLayers = {
  'standard': MapLayerConfig(
    name: 'Standard',
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    icon: Icons.map,
  ),
  'satellite': MapLayerConfig(
    name: 'Satellite',
    urlTemplate:
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
    icon: Icons.satellite,
  ),
  'cycle': MapLayerConfig(
    name: 'Cycle Map',
    urlTemplate:
        'https://tile.thunderforest.com/cycle/{z}/{x}/{y}.png?apikey=685265794bee48c1a91192c232fb2d2a',
    icon: Icons.directions_bike,
    requiresApiKey: true,
  ),
  'transport': MapLayerConfig(
    name: 'Transport',
    urlTemplate:
        'https://tile.thunderforest.com/transport/{z}/{x}/{y}.png?apikey=685265794bee48c1a91192c232fb2d2a',
    icon: Icons.directions_bus,
    requiresApiKey: true,
  ),
  'landscape': MapLayerConfig(
    name: 'Landscape',
    urlTemplate:
        'https://tile.thunderforest.com/landscape/{z}/{x}/{y}.png?apikey=685265794bee48c1a91192c232fb2d2a',
    icon: Icons.landscape,
    requiresApiKey: true,
  ),
  'outdoors': MapLayerConfig(
    name: 'Outdoors',
    urlTemplate:
        'https://tile.thunderforest.com/outdoors/{z}/{x}/{y}.png?apikey=685265794bee48c1a91192c232fb2d2a',
    icon: Icons.forest,
    requiresApiKey: true,
  ),
  'dark': MapLayerConfig(
    name: 'Dark',
    urlTemplate:
        'https://tile.thunderforest.com/transport-dark/{z}/{x}/{y}.png?apikey=685265794bee48c1a91192c232fb2d2a',
    icon: Icons.dark_mode,
    requiresApiKey: true,
  ),
};

class MapRadiusOverlay extends StatelessWidget {
  final double radius;
  final LatLng location;
  const MapRadiusOverlay(
      {required this.radius, required this.location, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleLayer(circles: [
      CircleMarker(
        point: location,
        radius: radius,
        useRadiusInMeter: true,
        color: Colors.blue.withOpacity(0.3),
        borderColor: Colors.blue,
        borderStrokeWidth: 2,
      ),
    ]);
  }
}

class MapMarker extends StatelessWidget {
  final LatLng location;
  final VoidCallback onTap;
  const MapMarker({required this.location, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(markers: [
      Marker(
        width: 80.0,
        height: 80.0,
        point: location,
        child: IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.location_on, color: Colors.red, size: 40.0)),
      ),
    ]);
  }
}

class MapAttribution extends StatelessWidget {
  const MapAttribution({super.key});

  @override
  Widget build(BuildContext context) {
    return RichAttributionWidget(
      attributions: [
        TextSourceAttribution('OpenStreetMap contributors', onTap: () async {
          final Uri url = Uri.parse('https://openstreetmap.org/copyright');
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        }),
      ],
    );
  }
}

class MapControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onLocate;
  const MapControls(
      {required this.onZoomIn,
      required this.onZoomOut,
      required this.onLocate,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 16,
        bottom: 16,
        child: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: onLocate,
            child: const Icon(Icons.my_location)));
  }
}

class RadiusControl extends StatelessWidget {
  final double radius;
  final double minRadius;
  final double maxRadius;
  final ValueChanged<double> onChanged;

  const RadiusControl({
    super.key,
    required this.radius,
    required this.minRadius,
    required this.maxRadius,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Radius',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${radius.toStringAsFixed(0)}m',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: Colors.blue.withOpacity(0.7),
                  thumbColor: Colors.blue,
                  overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
                ),
                child: Slider(
                  value: radius,
                  min: minRadius,
                  max: maxRadius,
                  divisions: 49,
                  label: '${radius.toStringAsFixed(0)}m',
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
