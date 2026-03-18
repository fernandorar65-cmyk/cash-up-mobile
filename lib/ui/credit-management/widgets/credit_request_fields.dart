import 'package:flutter/material.dart';

class CreditRequestFields extends StatelessWidget {
  const CreditRequestFields({
    super.key,
    required this.amountController,
    required this.termController,
    required this.purposeController,
    required this.notesController,
    required this.currency,
    required this.onCurrencyChanged,
  });

  final TextEditingController amountController;
  final TextEditingController termController;
  final TextEditingController purposeController;
  final TextEditingController notesController;

  final String currency;
  final ValueChanged<String> onCurrencyChanged;

  static const _primary = Color(0xFF0A202E);
  static const _border = Color(0xFFE2E8F0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(text: 'Monto del préstamo'),
        const SizedBox(height: 8),
        TextField(
          controller: amountController,
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
          value: currency,
          items: const [
            DropdownMenuItem(value: 'PEN', child: Text('Soles (PEN)')),
            DropdownMenuItem(value: 'USD', child: Text('Dólares (USD)')),
          ],
          onChanged: (v) {
            if (v == null) return;
            onCurrencyChanged(v);
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
          controller: termController,
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
          controller: purposeController,
          decoration: _input(
            hintText: 'Ej. Remodelación, Estudios...',
            icon: Icons.flag_outlined,
          ),
        ),
        const SizedBox(height: 14),
        _FieldLabel(text: 'Notas adicionales (Opcional)'),
        const SizedBox(height: 8),
        TextField(
          controller: notesController,
          maxLines: 3,
          decoration: _input(
            hintText: 'Añada información relevante...',
            icon: Icons.notes_outlined,
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 12),
      ],
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
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
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

