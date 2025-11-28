import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';

class OrderTrackingScreen extends StatefulWidget {
  final String orderId;
  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with TickerProviderStateMixin {
  late final AnimatedMapController _mapController =
  AnimatedMapController(vsync: this);

  // This is always non-null
  LatLng _driverLocation = const LatLng(9.1538486, 7.3219648);
  String? _driverId;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  Future<void> _startTracking() async {
    await _loadDriverId();
    if (!mounted) return;

    // Show map immediately
    setState(() {});

    if (_driverId == null) return;

    await _ensureLocationRowExists();
    await _loadCurrentLocation();
    _listenToLiveUpdates();
  }

  Future<void> _loadDriverId() async {
    try {
      final resp = await Supabase.instance.client
          .from('orders')
          .select('driver_id')
          .eq('id', widget.orderId)
          .single();

      final id = resp['driver_id'];
      if (id != null) {
        _driverId = id.toString();
        debugPrint('Driver assigned: $_driverId');
      }
    } catch (e) {
      debugPrint('No driver yet or error: $e');
    }
  }

  Future<void> _ensureLocationRowExists() async {
    if (_driverId == null) return;
    try {
      await Supabase.instance.client.from('driver_locations').upsert({
        'driver_id': _driverId,
        'lat': _driverLocation.latitude,
        'lng': _driverLocation.longitude,
      }, onConflict: 'driver_id');
    } catch (e) {
      debugPrint('Upsert failed: $e');
    }
  }

  Future<void> _loadCurrentLocation() async {
    if (_driverId == null) return;
    try {
      final data =await Supabase.instance.client
          .from('driver_locations')
          .upsert({
        'driver_id': _driverId,
        'lat': 9.0765,  // Abuja latitude
        'lng': 7.3986,  // Abuja longitude
      }, onConflict: 'driver_id');


      if (data != null) {
        final lat = (data['lat'] as num).toDouble();
        final lng = (data['lng'] as num).toDouble();
        _driverLocation = LatLng(lat, lng);

        _mapController.animateTo(dest: _driverLocation, zoom: 16.0);
        if (mounted) setState(() {});
      }
    } catch (e) {
      debugPrint('Load location failed: $e');
    }
  }

  void _listenToLiveUpdates() {
    _channel?.unsubscribe();
    _channel = Supabase.instance.client
        .channel('tracking_${widget.orderId}')
        .onPostgresChanges(
      event: PostgresChangeEvent.update,
      schema: 'public',
      table: 'driver_locations',
      callback: (payload) {
        final lat = payload.newRecord?['lat'];
        final lng = payload.newRecord?['lng'];
        if (lat is num && lng is num) {
          final newPos = LatLng(lat.toDouble(), lng.toDouble());
          debugPrint('Driver moved → $newPos');

          setState(() => _driverLocation = newPos);
          _mapController.animateTo(
            dest: newPos,
            duration: const Duration(milliseconds: 1800),
            curve: Curves.easeOutCubic,
          );
        }
      },
    )
        .subscribe();
  }

  @override
  void dispose() {
    _channel?.unsubscribe();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Tracking',
            style: TextStyle(
                color: AppColors.buttonBg,
                fontWeight: FontWeight.w700),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController.mapController,
            options: MapOptions(
              initialCenter: _driverLocation,
              initialZoom: 16.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.godrop',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _driverLocation,
                    width: 100,
                    height: 100,
                    alignment: Alignment.topCenter,
                    child: const Icon(
                        Icons.drive_eta,
                        color: AppColors.red,
                        size: 30),
                  ),
                ],
              ),
              Positioned(
                bottom: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse('https://www.openstreetmap.org/copyright'),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('© OpenStreetMap',
                        style: TextStyle(fontSize: 11)),
                  ),
                ),
              ),
            ],
          ),

          // Optional small indicator while waiting for real location
          if (_driverId == null)
            const Positioned(
              top: 16,
              left: 16,
              child: Card(
                color: Colors.black87,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      ),
                      SizedBox(width: 8),
                      Text('Waiting for driver assignment…',
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}