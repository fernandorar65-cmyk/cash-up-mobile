import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../di/datasource_providers.dart';

class CreditRequestScreen extends ConsumerStatefulWidget {
  const CreditRequestScreen({super.key});

  static const routeName = 'credit_request';
  static const routePath = '/credit-request';

  @override
  ConsumerState<CreditRequestScreen> createState() => _CreditRequestScreenState();
}

class _CreditRequestScreenState extends ConsumerState<CreditRequestScreen> {
  final _amountController = TextEditingController();
  final _termController = TextEditingController(text: '12');
  final _purposeController = TextEditingController();
  final _notesController = TextEditingController();

  String _currency = 'PEN';
  bool _isSubmitting = false;

  static const _primary = Color(0xFF0A202E);
  static const _bg = Color(0xFFF6F7F8);
  static const _muted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);

  @override
  void dispose() {
    _amountController.dispose();
    _termController.dispose();
    _purposeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final requestedAmount = num.tryParse(_amountController.text.trim());
    final termMonths = int.tryParse(_termController.text.trim());

    if (requestedAmount == null || requestedAmount <= 0 || termMonths == null || termMonths <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monto y plazo deben ser válidos')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await ref.read(creditRequestsServiceProvider).create(
            requestedAmount: requestedAmount,
            termMonths: termMonths,
            currency: _currency,
            purpose: _purposeController.text.trim().isEmpty ? null : _purposeController.text.trim(),
            clientNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solicitud enviada correctamente')),
      );

      _amountController.clear();
      _purposeController.clear();
      _notesController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        title: const Text('Nueva solicitud'),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () {
            // Como esta pantalla vive dentro de `Home` (tab), forzamos volver al home
            // para que el estado del tab vuelva al inicio (index 0).
            // Si en el futuro navegas como ruta normal, `maybePop` también funcionará.
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).maybePop();
              return;
            }
            // fallback: recargar home
            context.go('/home');
          },
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Detalles del préstamo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Complete los campos para procesar su crédito.',
                        style: TextStyle(fontSize: 12, color: _muted, height: 1.25),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _FieldLabel(text: 'Monto del préstamo'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: _input(
                                  hintText: '0.00',
                                  icon: Icons.payments_outlined,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _FieldLabel(text: 'Moneda'),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _currency,
                                items: const [
                                  DropdownMenuItem(value: 'PEN', child: Text('Soles (PEN)')),
                                  DropdownMenuItem(value: 'USD', child: Text('Dólares (USD)')),
                                ],
                                onChanged: (v) {
                                  if (v == null) return;
                                  setState(() => _currency = v);
                                },
                                decoration: _input(
                                  hintText: '',
                                  icon: Icons.currency_exchange,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _FieldLabel(text: 'Plazo (Meses)'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _termController,
                                keyboardType: TextInputType.number,
                                decoration: _input(
                                  hintText: 'Ej. 12',
                                  icon: Icons.calendar_month_outlined,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _FieldLabel(text: 'Propósito'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _purposeController,
                                decoration: _input(
                                  hintText: 'Ej. Remodelación, Estudios...',
                                  icon: Icons.flag_outlined,
                                ),
                              ),
                              const SizedBox(height: 14),
                              _FieldLabel(text: 'Notas adicionales (Opcional)'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _notesController,
                                maxLines: 3,
                                decoration: _input(
                                  hintText: 'Añada información relevante...',
                                  icon: Icons.notes_outlined,
                                  alignLabelWithHint: true,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: _primary,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.18),
                                blurRadius: 16,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _isSubmitting
                                    ? const SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Enviar solicitud',
                                        style: TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                const SizedBox(width: 10),
                                const Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Al enviar esta solicitud, usted acepta nuestros\n'
                        'términos y condiciones de procesamiento crediticio.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFF94A3B8),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _input({
    required String hintText,
    required IconData icon,
    bool alignLabelWithHint = false,
  }) {
    return InputDecoration(
      hintText: hintText,
      alignLabelWithHint: alignLabelWithHint,
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _primary, width: 1.5),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Color(0xFF0F172A),
      ),
    );
  }
}