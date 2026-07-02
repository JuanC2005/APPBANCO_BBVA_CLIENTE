import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaPickerScreen extends StatefulWidget {
  final double? latInicial;
  final double? lngInicial;

  const MapaPickerScreen({super.key, this.latInicial, this.lngInicial});

  @override
  State<MapaPickerScreen> createState() => _MapaPickerScreenState();
}

class _MapaPickerScreenState extends State<MapaPickerScreen> {
  late LatLng _posicion;
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _posicion = LatLng(
      widget.latInicial ?? -12.0653,
      widget.lngInicial ?? -75.2049,
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _confirmar() async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar ubicación'),
        content: const Text(
          '¿Está seguro de registrar esta ubicación como la de su negocio?\n\n'
          'No podrá modificarla después.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
    if (confirmado == true && mounted) {
      Navigator.pop(context, {
        'lat': _posicion.latitude,
        'lng': _posicion.longitude,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Elegir ubicación')),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _posicion,
              initialZoom: 15.0,
              onTap: (tapPos, latlng) => setState(() => _posicion = latlng),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.bbva.cliente',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _posicion,
                    width: 40,
                    height: 40,
                    child: const Icon(Icons.location_on, color: Colors.red, size: 40),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 8,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Arrastra el mapa para colocar el pin',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 80,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                child: Text(
                  '${_posicion.latitude.toStringAsFixed(6)}, ${_posicion.longitude.toStringAsFixed(6)}',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _confirmar,
        icon: const Icon(Icons.check),
        label: const Text('Confirmar ubicación'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
