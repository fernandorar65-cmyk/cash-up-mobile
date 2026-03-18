import 'package:flutter/material.dart';

import 'home_factor_item.dart';

class HomeScoringView extends StatelessWidget {
  const HomeScoringView({super.key});

  static const _primary = Color(0xFF0A202E);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _ScoreHero(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Desglose de factores',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 16),
                HomeFactorItem(
                  icon: Icons.history,
                  title: 'Historial de pagos',
                  label: 'Excelente',
                  percent: 0.95,
                ),
                SizedBox(height: 16),
                HomeFactorItem(
                  icon: Icons.payments_outlined,
                  title: 'Capacidad de pago',
                  label: 'Muy buena',
                  percent: 0.78,
                ),
                SizedBox(height: 16),
                HomeFactorItem(
                  icon: Icons.work_history_outlined,
                  title: 'Estabilidad laboral',
                  label: 'Buena',
                  percent: 0.65,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primary,
                      foregroundColor: Colors.white,
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text(
                      'Recalcular scoring',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Última actualización: hace 2 días',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF94A3B8),
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            HomeScoringView._primary.withValues(alpha: 0.05),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            width: 190,
            height: 190,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: const CircularProgressIndicator(
                    value: 0.82,
                    strokeWidth: 10,
                    backgroundColor: Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HomeScoringView._primary,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '820',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: HomeScoringView._primary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'PUNTOS',
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: 1.8,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified_user,
                  size: 18,
                  color: Color(0xFF15803D),
                ),
                SizedBox(width: 6),
                Text(
                  'Nivel: Bajo Riesgo',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF166534),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Tu puntaje es excelente. Tienes altas probabilidades de aprobación para nuevos créditos con tasas preferenciales.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

