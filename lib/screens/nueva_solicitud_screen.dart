import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/api_client_provider.dart';
import '../providers/solicitudes_provider.dart';
import '../theme/app_theme.dart';
import 'mapa_picker_screen.dart';

class NuevaSolicitudScreen extends ConsumerStatefulWidget {
  const NuevaSolicitudScreen({super.key});

  @override
  ConsumerState<NuevaSolicitudScreen> createState() => _NuevaSolicitudScreenState();
}

class _NuevaSolicitudScreenState extends ConsumerState<NuevaSolicitudScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoController = TextEditingController();
  bool _conSeguro = false;
  int _plazo = 12;
  String _destino = 'Capital de trabajo';
  String _garantia = 'sin_garantia';
  bool _enviando = false;

  final _destinos = [
    'Capital de trabajo',
    'Compra de mercadería',
    'Maquinaria',
    'Ampliación',
    'Compra de vehículo',
    'Otro',
  ];

  final _garantias = {
    'sin_garantia': 'Sin garantía',
    'aval': 'Aval',
    'hipotecaria': 'Hipotecaria',
    'prendaria': 'Prendaria',
    'vehicular': 'Vehicular',
  };

  double get _tea => _conSeguro ? 40.92 : 43.92;
  double get _tem => pow(1 + _tea / 100, 1 / 12).toDouble() - 1;

  double _calcularCuota(double monto) {
    if (monto <= 0 || _plazo <= 0) return 0;
    if (_tem <= 0) return monto / _plazo;
    return monto * _tem / (1 - pow(1 + _tem, -_plazo).toDouble());
  }

  @override
  void dispose() {
    _montoController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;
    final monto = double.tryParse(_montoController.text) ?? 0;
    if (monto <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingrese un monto válido')),
      );
      return;
    }

    setState(() => _enviando = true);

    try {
      final solicitud = await ref.read(crearSolicitudProvider({
        'monto': monto,
        'plazo': _plazo,
        'destino': _destino,
        'garantia': _garantia,
        'con_seguro': _conSeguro,
      }).future);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud enviada con éxito'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        final id = solicitud.id;
        final opcion = await showModalBottomSheet<String>(
          context: context,
          builder: (_) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('¿Deseas agregar la ubicación de visita?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Esto ayudará al asesor a encontrarte.',
                      style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text('Usar mi ubicación actual'),
                      onPressed: () => Navigator.pop(context, 'gps'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.map),
                      label: const Text('Elegir en el mapa'),
                      onPressed: () => Navigator.pop(context, 'mapa'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'skip'),
                    child: const Text('Ahora no'),
                  ),
                ],
              ),
            ),
          ),
        );
        if (opcion == 'gps' || opcion == 'mapa') {
          double? lat, lng;
          if (opcion == 'gps') {
            final pos = await Geolocator.getCurrentPosition();
            lat = pos.latitude;
            lng = pos.longitude;
          } else {
            final result = await context.push<Map<String, dynamic>>('/mapa-picker');
            if (result != null) {
              lat = result['lat'] as double;
              lng = result['lng'] as double;
            }
          }
          if (lat != null && lng != null && mounted) {
            final api = ref.read(apiClientProvider);
            await api.put('/homebanking/solicitudes/$id/ubicacion', {
              'lat_captura': lat,
              'lng_captura': lng,
            });
          }
        }
        if (mounted) {
          ref.invalidate(solicitudesProvider);
          context.go('/home/mis-solicitudes');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al enviar: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);
    final monto = double.tryParse(_montoController.text) ?? 0;
    final cuota = _calcularCuota(monto);

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva Solicitud de Crédito')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Producto: Crédito Empresarial - Microempresa',
                        style: Theme.of(context).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('TEA: ${_tea.toStringAsFixed(2)}%',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        const Spacer(),
                        Text('TEM: ${(_tem * 100).toStringAsFixed(2)}%',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _montoController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto solicitado (S/)',
                prefixIcon: Icon(Icons.monetization_on_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Ingrese un monto';
                final n = double.tryParse(v);
                if (n == null || n <= 0) return 'Monto inválido';
                return null;
              },
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Text('Plazo: $_plazo meses'),
            Slider(
              value: _plazo.toDouble(),
              min: 3,
              max: 48,
              divisions: 45,
              label: '$_plazo meses',
              onChanged: (v) => setState(() => _plazo = v.round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Min: 3'),
                Text('${_plazo} meses'),
                const Text('Max: 48'),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _destino,
              decoration: const InputDecoration(
                labelText: 'Destino del crédito',
                prefixIcon: Icon(Icons.shopping_cart_outlined),
                border: OutlineInputBorder(),
              ),
              items: _destinos.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
              onChanged: (v) => setState(() => _destino = v!),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _garantia,
              decoration: const InputDecoration(
                labelText: 'Garantía',
                prefixIcon: Icon(Icons.verified_user_outlined),
                border: OutlineInputBorder(),
              ),
              items: _garantias.entries
                  .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                  .toList(),
              onChanged: (v) => setState(() => _garantia = v!),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Con seguro de desgravamen'),
              subtitle: Text(_conSeguro ? 'TEA: 40.92%' : 'TEA: 43.92% (sin seguro)'),
              value: _conSeguro,
              onChanged: (v) => setState(() => _conSeguro = v),
            ),
            const SizedBox(height: 16),
            if (monto > 0) ...[
              Card(
                color: AppColors.primaryBlue,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text('Cuota mensual estimada',
                          style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text(f.format(cuota),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Plazo: $_plazo meses | TEA: ${_tea.toStringAsFixed(2)}%',
                          style: const TextStyle(color: Colors.white60, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text('Total a pagar: ${f.format(cuota * _plazo)}',
                  style: const TextStyle(color: Colors.grey)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: _enviando ? null : _enviar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                ),
                child: _enviando
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Enviar Solicitud', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
