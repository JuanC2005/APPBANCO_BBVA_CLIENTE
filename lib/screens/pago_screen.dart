import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/creditos_provider.dart';
import '../providers/cuentas_provider.dart';
import '../providers/api_client_provider.dart';
import '../theme/app_theme.dart';

class PagoScreen extends ConsumerStatefulWidget {
  const PagoScreen({super.key});

  @override
  ConsumerState<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends ConsumerState<PagoScreen> {
  String? _creditoId;
  String? _cuentaOrigenId;
  final _montoCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _enviando = false;

  @override
  void dispose() {
    _montoCtrl.dispose();
    super.dispose();
  }

  Future<void> _pagar() async {
    if (!_formKey.currentState!.validate() || _creditoId == null || _cuentaOrigenId == null) return;
    setState(() => _enviando = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.post('/homebanking/pagos', {
        'credito_id': _creditoId,
        'monto': double.parse(_montoCtrl.text.trim()),
        'cuenta_origen_id': _cuentaOrigenId,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago realizado con éxito'), backgroundColor: AppColors.successGreen),
        );
        Navigator.of(context).pop();
        ref.invalidate(creditosProvider);
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
    final creditosAsync = ref.watch(creditosProvider);
    final cuentasAsync = ref.watch(cuentasProvider);
    final f = NumberFormat.currency(symbol: 'S/', decimalDigits: 2);

    return Scaffold(
      appBar: AppBar(title: const Text('Pago de Cuota')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Seleccione el crédito', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              creditosAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (creditos) => DropdownButtonFormField<String>(
                  initialValue: _creditoId,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.credit_score)),
                  hint: const Text('Seleccione crédito'),
                  items: creditos.where((c) => c.saldoActual > 0).map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.producto} — Saldo: ${f.format(c.saldoActual)}'),
                  )).toList(),
                  onChanged: (v) => setState(() => _creditoId = v),
                  validator: (v) => v == null ? 'Seleccione un crédito' : null,
                ),
              ),
              const SizedBox(height: 16),
              Text('Cuenta de origen', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              cuentasAsync.when(
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text('Error: $e'),
                data: (cuentas) => DropdownButtonFormField<String>(
                  initialValue: _cuentaOrigenId,
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.account_balance)),
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
                controller: _montoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Monto a pagar (S/)',
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese un monto';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) return 'Monto inválido';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _enviando ? null : _pagar,
                  child: _enviando
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('PAGAR CUOTA', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
