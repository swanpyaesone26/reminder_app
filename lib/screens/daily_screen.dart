import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  @override
  void initState() {
    super.initState();
    // Load daily notes when screen opens
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
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.white, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Note field
                  Text(
                    'Note',
                    style: GoogleFonts.caveat(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: textController,
                      style: GoogleFonts.caveat(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      maxLines: 3,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Reminder field
                  Text(
                    'Reminder (Optional)',
                    style: GoogleFonts.caveat(
                      color: Colors.white,
                      fontSize: 20,
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
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            selectedTime != null
                                ? '${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}'
                                : 'Set time',
                            style: GoogleFonts.caveat(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Add',
                            style: GoogleFonts.caveat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.add_box_outlined,
                              color: Colors.white, size: 24),
                        ],
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Daily Plan',
                    style: GoogleFonts.caveat(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Add Note button
              GestureDetector(
                onTap: _showAddNoteDialog,
                child: Row(
                  children: [
                    const Icon(Icons.add_box_outlined,
                        color: Colors.white, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'Add Note',
                      style: GoogleFonts.caveat(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Notes list
              Expanded(
                child: provider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                  children: [
                    // Undone section
                    if (provider.dailyUndone.isNotEmpty) ...[
                      _SectionBox(
                        title: 'Undone',
                        notes: provider.dailyUndone,
                        provider: provider,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Done section
                    if (provider.dailyDone.isNotEmpty)
                      _SectionBox(
                        title: 'Done',
                        notes: provider.dailyDone,
                        provider: provider,
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

  const _SectionBox({
    required this.title,
    required this.notes,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.caveat(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
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
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // Checkbox
          GestureDetector(
            onTap: () => provider.toggleNote(note),
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(4),
                color: note.isDone
                    ? Colors.white.withOpacity(0.3)
                    : Colors.transparent,
              ),
              child: note.isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 16)
                  : null,
            ),
          ),
          const SizedBox(width: 10),

          // Note text
          Expanded(
            child: Text(
              note.text,
              style: GoogleFonts.caveat(
                color: Colors.white,
                fontSize: 18,
                decoration: note.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),

          // Delete button
          GestureDetector(
            onTap: () => provider.deleteNote(note),
            child: const Icon(Icons.delete_outline,
                color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }
}