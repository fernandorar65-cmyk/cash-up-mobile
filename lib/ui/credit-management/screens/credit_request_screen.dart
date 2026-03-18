import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../di/repository_providers.dart';
import '../../../services/api/api_exception.dart';
import '../widgets/credit_request_fields.dart';
import '../widgets/credit_request_submit_bar.dart';

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

  Future<void> _showApiError(Object error) async {
    if (!mounted) return;

    String title = 'No se pudo enviar';
    String message = 'Inténtalo nuevamente.';

    if (error is ApiException) {
      message = error.message;
      if (error.statusCode == 401) {
        message = 'Tu sesión expiró. Vuelve a iniciar sesión.';
      }
    }

    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
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
      await ref.read(creditRequestsRepositoryProvider).create(
            requestedAmount: requestedAmount,
            termMonths: termMonths,
            currency: _currency,
            purpose: _purposeController.text.trim().isEmpty ? null : _purposeController.text.trim(),
            clientNotes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
          );

      if (!mounted) return;
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: const Text('Solicitud enviada'),
            content: const Text(
              'Tu solicitud de crédito fue enviada correctamente.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );

      _amountController.clear();
      _purposeController.clear();
      _notesController.clear();

      if (!mounted) return;
      // Regresar a la vista anterior (Solicitudes/Mis créditos).
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      } else {
        context.go('/home');
      }
    } catch (e) {
      await _showApiError(e);
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
                      color: Colors.black.withValues(alpha: 0.06),
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
                          child: CreditRequestFields(
                            amountController: _amountController,
                            termController: _termController,
                            purposeController: _purposeController,
                            notesController: _notesController,
                            currency: _currency,
                            onCurrencyChanged: (v) {
                              setState(() => _currency = v);
                            },
                          ),
                        ),
                      ),
                      CreditRequestSubmitBar(
                        isSubmitting: _isSubmitting,
                        onSubmit: _submit,
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