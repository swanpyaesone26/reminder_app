import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

const _accent = Color(0xFF6C63FF);

class MonthlyScreen extends StatefulWidget {
  const MonthlyScreen({super.key});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().loadNotes('monthly');
    });
  }

  // ─────────────────────────────────────
  // ADD NOTE DIALOG
  // ─────────────────────────────────────
  void _showAddNoteDialog() {
    final textController = TextEditingController();
    DateTime? selectedDate;

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
                        child: const Icon(Icons.calendar_month,
                            color: _accent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      const Expanded( // Fixed overflow
                        child: Text(
                          'New Monthly Reminder',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22, // Slightly reduced font size
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Note field
                  const Text(
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
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(14),
                        hintText: 'What\'s the reminder this month?',
                        hintStyle: TextStyle(
                          color: Colors.white24,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reminder date field
                  const Text(
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
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 2),
                        builder: (context, child) {
                          return Theme(
                            data: ThemeData.dark(),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setDialogState(() => selectedDate = date);
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
                          Icon(Icons.calendar_today,
                              color: selectedDate != null
                                  ? _accent
                                  : Colors.white38,
                              size: 20),
                          const SizedBox(width: 8),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                : 'Set date',
                            style: TextStyle(
                              color: selectedDate != null
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

                        final note = Note(
                          text: textController.text.trim(),
                          type: 'monthly',
                          reminder: selectedDate,
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
                        child: const Row(
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
                            SizedBox(width: 6),
                            Icon(Icons.add_circle_outline,
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
                    child: const Icon(Icons.calendar_month,
                        color: _accent, size: 22),
                  ),
                  const SizedBox(width: 10),
                  const Expanded( // Fixed overflow
                    child: Text(
                      'Monthly Reminders',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26, // Slightly reduced font size
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: _accent, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Add Reminder',
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
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: _accent, strokeWidth: 2))
                    : ListView(
                        children: [
                          if (provider.monthlyUndone.isNotEmpty) ...[
                            _SectionBox(
                              title: 'Undone',
                              notes: provider.monthlyUndone,
                              provider: provider,
                              isUndone: true,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (provider.monthlyDone.isNotEmpty)
                            _SectionBox(
                              title: 'Done',
                              notes: provider.monthlyDone,
                              provider: provider,
                              isUndone: false,
                            ),
                          if (provider.monthlyUndone.isEmpty &&
                              provider.monthlyDone.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 60),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.check_circle_outline,
                                        color: Colors.white12,
                                        size: 48),
                                    SizedBox(height: 12),
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
// SECTION BOX WIDGET
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

          // Note text + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
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
                if (note.reminder != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: _accent.withValues(alpha: 0.5), size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${note.reminder!.day}/${note.reminder!.month}/${note.reminder!.year}',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
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
