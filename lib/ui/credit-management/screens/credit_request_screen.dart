import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: _primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.edit_note, color: _primary),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nueva solicitud',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: _primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Completa los datos para enviar tu solicitud.',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFF64748B),
                                    height: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 16),
                      _SectionLabel(text: 'Monto y plazo'),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Monto',
                                hintText: 'Ej: 1500',
                                prefixIcon: const Icon(Icons.payments_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _termController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Meses',
                                hintText: '12',
                                prefixIcon: const Icon(Icons.calendar_month_outlined),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _currency,
                        items: const [
                          DropdownMenuItem(value: 'PEN', child: Text('PEN')),
                          DropdownMenuItem(value: 'USD', child: Text('USD')),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => _currency = v);
                        },
                        decoration: InputDecoration(
                          labelText: 'Moneda',
                          prefixIcon: const Icon(Icons.currency_exchange),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SectionLabel(text: 'Información adicional (opcional)'),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _purposeController,
                        decoration: InputDecoration(
                          labelText: 'Propósito',
                          hintText: 'Ej: capital de trabajo',
                          prefixIcon: const Icon(Icons.flag_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: 'Notas',
                          hintText: 'Cuéntanos cualquier detalle importante…',
                          alignLabelWithHint: true,
                          prefixIcon: const Icon(Icons.notes_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _submit,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.send_rounded),
                          label: Text(_isSubmitting ? 'Enviando…' : 'Enviar solicitud'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primary,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Recuerda: la aprobación la realiza el equipo de CashUp.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF94A3B8),
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
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.2,
        color: Color(0xFF0F172A),
      ),
    );
  }
}