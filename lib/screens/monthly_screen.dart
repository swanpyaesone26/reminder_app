import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/note_provider.dart';

class MonthlyScreen extends StatefulWidget {
  const MonthlyScreen({super.key});

  @override
  State<MonthlyScreen> createState() => _MonthlyScreenState();
}

class _MonthlyScreenState extends State<MonthlyScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NoteProvider>().loadNotes('monthly'));
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

                  // Reminder date field
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
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            selectedDate != null
                                ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                                : 'Set date',
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

                        final note = Note(
                          text: textController.text.trim(),
                          type: 'monthly',
                          reminder: selectedDate,
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
                    'Monthly Plan',
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
                    if (provider.monthlyUndone.isNotEmpty) ...[
                      _SectionBox(
                        title: 'Undone',
                        notes: provider.monthlyUndone,
                        provider: provider,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Done section
                    if (provider.monthlyDone.isNotEmpty)
                      _SectionBox(
                        title: 'Done',
                        notes: provider.monthlyDone,
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
// SECTION BOX WIDGET
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

          // Note text + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.text,
                  style: GoogleFonts.caveat(
                    color: Colors.white,
                    fontSize: 18,
                    decoration: note.isDone
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                // Show reminder date if set
                if (note.reminder != null)
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Colors.white60, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${note.reminder!.day}/${note.reminder!.month}/${note.reminder!.year}',
                        style: GoogleFonts.caveat(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
              ],
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