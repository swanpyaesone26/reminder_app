import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';
import 'daily_screen.dart';
import 'monthly_screen.dart';
import 'yearly_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final provider = context.read<NoteProvider>();
    provider.loadNotes('daily');
    provider.loadNotes('monthly');
    provider.loadNotes('yearly');
  }

  void _navigate(BuildContext context, Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
    if (!mounted) return;
    final provider = context.read<NoteProvider>();
    provider.loadNotes('daily');
    provider.loadNotes('monthly');
    provider.loadNotes('yearly');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Consumer<NoteProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App title
                  const Text(
                    'RemindMe',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _getGreeting(),
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Top row - Monthly & Yearly
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          child: _NavCard(
                            icon: Icons.calendar_month,
                            label: 'Monthly',
                            accentColor: const Color(0xFF6C63FF),
                            undoneNotes: provider.monthlyUndone,
                            onTap: () =>
                                _navigate(context, const MonthlyScreen()),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _NavCard(
                            icon: Icons.calendar_today,
                            label: 'Yearly',
                            accentColor: const Color(0xFFFF6B6B),
                            undoneNotes: provider.yearlyUndone,
                            onTap: () =>
                                _navigate(context, const YearlyScreen()),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  // Bottom - Daily Card
                  Expanded(
                    flex: 2,
                    child: _NavCard(
                      icon: Icons.edit_calendar,
                      label: 'Daily',
                      accentColor: const Color(0xFF4ECDC4),
                      undoneNotes: provider.dailyUndone,
                      onTap: () => _navigate(context, const DailyScreen()),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤️';
    return 'Good evening 🌙';
  }
}

class _NavCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final List<Note> undoneNotes;
  final VoidCallback onTap;

  const _NavCard({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.undoneNotes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF2D2D2D),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: icon + label + count badge
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20, // Reduced icon size slightly
                    color: accentColor,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded( // Added Expanded here to prevent overflow
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18, // Reduced font size slightly for tight layouts
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
                  ),
                ),
                if (undoneNotes.isNotEmpty) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${undoneNotes.length}',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 14),
            // Divider
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.06),
            ),
            const SizedBox(height: 10),
            // Undone tasks list
            Expanded(
              child: undoneNotes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Colors.white.withValues(alpha: 0.15),
                            size: 32,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'All done!',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.transparent,
                        ],
                        stops: [0.0, 0.75, 1.0],
                      ).createShader(bounds),
                      blendMode: BlendMode.dstIn,
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: undoneNotes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  undoneNotes[index].text,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 17,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
