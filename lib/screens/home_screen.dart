import 'package:flutter/material.dart';
import 'daily_screen.dart';
import 'monthly_screen.dart';
import 'yearly_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Top row - Monthly & Yearly
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    // Monthly Card
                    Expanded(
                      child: _NavCard(
                        icon: Icons.calendar_month,
                        label: 'Monthly',
                        onTap: () => _navigate(context, const MonthlyScreen()),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Yearly Card
                    Expanded(
                      child: _NavCard(
                        icon: Icons.calendar_today,
                        label: 'Yearly',
                        onTap: () => _navigate(context, const YearlyScreen()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Bottom - Daily Card (2x height)
              Expanded(
                flex: 2,
                child: _NavCard(
                  icon: Icons.edit_calendar,
                  label: 'Daily',
                  onTap: () => _navigate(context, const DailyScreen()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}