import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

const _accent = Color(0xFF4ECDC4);

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NoteProvider>().loadNotes('daily'));
  }

  // ─────────────────────────────────────
  // ADD NOTE DIALOG
  // ─────────────────────────────────────
  void _showAddNoteDialog() {
    final textController = TextEditingController();
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: const Color(0xFF2D2D2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: _accent.withValues(alpha: 0.3), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.edit_calendar,
                            color: _accent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'New Daily Note',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Note field
                  Text(
                    'Note',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.05),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12), width: 1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: textController,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(14),
                        hintText: 'What do you need to do?',
                        hintStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reminder field
                  Text(
                    'Reminder (Optional)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        builder: (context, child) {
                          return MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              alwaysUse24HourFormat: true,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (time != null) {
                        setDialogState(() => selectedTime = time);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.access_time,
                              color: selectedTime != null
                                  ? _accent
                                  : Colors.white38,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            selectedTime != null
                                ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                                : 'Set time',
                            style: TextStyle(
                              color: selectedTime != null
                                  ? Colors.white
                                  : Colors.white38,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Add button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        if (textController.text.trim().isEmpty) return;

                        DateTime? reminderDateTime;
                        if (selectedTime != null) {
                          final now = DateTime.now();
                          reminderDateTime = DateTime(
                            now.year,
                            now.month,
                            now.day,
                            selectedTime!.hour,
                            selectedTime!.minute,
                          );
                        }

                        final note = Note(
                          text: textController.text.trim(),
                          type: 'daily',
                          reminder: reminderDateTime,
                        );

                        context.read<NoteProvider>().addNote(note);
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Add',
                              style: TextStyle(
                                color: _accent,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.add_circle_outline,
                                color: _accent, size: 22),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white70, size: 20),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.edit_calendar,
                        color: _accent, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Daily Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Add Note button
              GestureDetector(
                onTap: _showAddNoteDialog,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: _accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: _accent.withValues(alpha: 0.25), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_circle_outline,
                          color: _accent, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        'Add Note',
                        style: TextStyle(
                          color: _accent,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Notes list
              Expanded(
                child: provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                            color: _accent, strokeWidth: 2))
                    : ListView(
                        children: [
                          if (provider.dailyUndone.isNotEmpty) ...[
                            _SectionBox(
                              title: 'Undone',
                              notes: provider.dailyUndone,
                              provider: provider,
                              isUndone: true,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (provider.dailyDone.isNotEmpty)
                            _SectionBox(
                              title: 'Done',
                              notes: provider.dailyDone,
                              provider: provider,
                              isUndone: false,
                            ),
                          if (provider.dailyUndone.isEmpty &&
                              provider.dailyDone.isEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: Colors.white.withValues(
                                            alpha: 0.1),
                                        size: 48),
                                    const SizedBox(height: 12),
                                    Text(
                                      'No notes yet',
                                      style: TextStyle(
                                        color: Colors.white30,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────
// SECTION BOX WIDGET (Undone / Done)
// ─────────────────────────────────────
class _SectionBox extends StatelessWidget {
  final String title;
  final List<Note> notes;
  final NoteProvider provider;
  final bool isUndone;

  const _SectionBox({
    required this.title,
    required this.notes,
    required this.provider,
    required this.isUndone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUndone
              ? _accent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  color: isUndone ? _accent : Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  color: isUndone ? _accent : Colors.white54,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: (isUndone ? _accent : Colors.white24)
                      .withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${notes.length}',
                  style: TextStyle(
                    color: isUndone ? _accent : Colors.white54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...notes.map((note) => _NoteRow(note: note, provider: provider)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────
// NOTE ROW WIDGET
// ─────────────────────────────────────
class _NoteRow extends StatelessWidget {
  final Note note;
  final NoteProvider provider;

  const _NoteRow({required this.note, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => provider.toggleNote(note),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                border: Border.all(
                  color: note.isDone ? _accent : Colors.white30,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color: note.isDone
                    ? _accent.withValues(alpha: 0.2)
                    : Colors.transparent,
              ),
              child: note.isDone
                  ? const Icon(Icons.check, color: _accent, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 12),

          // Note text
          Expanded(
            child: Text(
              note.text,
              style: TextStyle(
                color: note.isDone ? Colors.white38 : Colors.white,
                fontSize: 18,
                decoration: note.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                decorationColor: Colors.white38,
              ),
            ),
          ),

          // Delete button
          GestureDetector(
            onTap: () => provider.deleteNote(note),
            child: Icon(Icons.delete_outline,
                color: Colors.white.withValues(alpha: 0.2), size: 20),
          ),
        ],
      ),
    );
  }
}