import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cuentas_provider.dart';
import '../providers/api_client_provider.dart';
import '../theme/app_theme.dart';

class TransferenciaScreen extends ConsumerStatefulWidget {
  const TransferenciaScreen({super.key});

  @override
  ConsumerState<TransferenciaScreen> createState() => _TransferenciaScreenState();
}

class _TransferenciaScreenState extends ConsumerState<TransferenciaScreen> {
  final _destinoCtrl = TextEditingController();
  final _montoCtrl = TextEditingController();
  final _descripcionCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _cuentaOrigenId;
  bool _enviando = false;

  @override
  void dispose() {
    _destinoCtrl.dispose();
    _montoCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate() || _cuentaOrigenId == null) return;
    setState(() => _enviando = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post('/homebanking/transferencias', {
        'cuenta_origen_id': _cuentaOrigenId,
        'cuenta_destino': _destinoCtrl.text.trim(),
        'monto': double.parse(_montoCtrl.text.trim()),
        'descripcion': _descripcionCtrl.text.trim(),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transferencia realizada con éxito'), backgroundColor: AppColors.successGreen),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cuentasAsync = ref.watch(cuentasProvider);
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Transferencia')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cuenta de origen', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              cuentasAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                  data: (cuentas) => DropdownButtonFormField<String>(
                    initialValue: _cuentaOrigenId,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  hint: const Text('Seleccione cuenta'),
                  items: cuentas.map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.numeroCuenta} — ${f.format(c.saldoActual)}'),
                  )).toList(),
                  onChanged: (v) => setState(() => _cuentaOrigenId = v),
                  validator: (v) => v == null ? 'Seleccione una cuenta' : null,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destinoCtrl,
                decoration: const InputDecoration(
                  labelText: 'Cuenta destino',
                  prefixIcon: Icon(Icons.account_balance_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Ingrese cuenta destino' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _montoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto (S/)',
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese un monto';
                  final monto = double.tryParse(v);
                  if (monto == null || monto <= 0) return 'Monto inválido';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descripcionCtrl,
                decoration: const InputDecoration(
                  labelText: 'Descripción (opcional)',
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _enviando ? null : _enviar,
                  child: _enviando
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('ENVIAR TRANSFERENCIA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
