import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../models/subnote_model.dart';
import '../providers/note_provider.dart';

const _accent = Color(0xFFFF6B6B);

class YearlyScreen extends StatefulWidget {
  const YearlyScreen({super.key});

  @override
  State<YearlyScreen> createState() => _YearlyScreenState();
}

class _YearlyScreenState extends State<YearlyScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<NoteProvider>().loadNotes('yearly'));
  }

  // ─────────────────────────────────────
  // ADD NOTE DIALOG
  // ─────────────────────────────────────
  void _showAddNoteDialog() {
    final noteController = TextEditingController();
    final subnoteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                    child: const Icon(Icons.calendar_today,
                        color: _accent, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'New Yearly Reminder',
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
                  controller: noteController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                    hintText: 'Your yearly reminder...',
                    hintStyle: TextStyle(
                      color: Colors.white24,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subnote field (optional)
              Text(
                'Sub-Note (Optional)',
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
                  controller: subnoteController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(14),
                    hintText: 'For your memory ...',
                    hintStyle: TextStyle(
                      color: Colors.white24,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Add button
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () async {
                    if (noteController.text.trim().isEmpty) return;

                    final note = Note(
                      text: noteController.text.trim(),
                      type: 'yearly',
                    );

                    await context.read<NoteProvider>().addNote(note);

                    if (subnoteController.text.trim().isNotEmpty) {
                      final subnote = Subnote(
                        noteId: note.id,
                        text: subnoteController.text.trim(),
                      );
                      await context.read<NoteProvider>().addSubnote(subnote);
                    }

                    if (context.mounted) Navigator.pop(context);
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
      ),
    );
  }

  // ─────────────────────────────────────
  // VIEW SUBNOTE POPUP
  // ─────────────────────────────────────
  void _showViewSubnotePopup(Note note) async {
    final provider = context.read<NoteProvider>();
    await provider.loadSubnotes(note.id);

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) => Consumer<NoteProvider>(
        builder: (context, provider, _) {
          final subnotes = provider.subnotes
              .where((s) => s.noteId == note.id)
              .toList();

          return Dialog(
            backgroundColor: const Color(0xFF2D2D2D),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                  color: _accent.withValues(alpha: 0.3), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main note
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _accent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.notes,
                            color: _accent, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          note.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                  const SizedBox(height: 16),

                  // Subnote
                  Text(
                    'Sub-Note',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  subnotes.isEmpty
                      ? Text(
                          'No sub-note added',
                          style: TextStyle(
                            color: Colors.white24,
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          subnotes.first.text,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18,
                          ),
                        ),
                  const SizedBox(height: 24),

                  // Close button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 18,
                          ),
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
                    child: const Icon(Icons.calendar_today,
                        color: _accent, size: 22),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Yearly Reminders',
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
                    ? Center(
                        child: CircularProgressIndicator(
                            color: _accent, strokeWidth: 2))
                    : ListView(
                        children: [
                          if (provider.yearlyUndone.isNotEmpty) ...[
                            _SectionBox(
                              title: 'Undone',
                              notes: provider.yearlyUndone,
                              provider: provider,
                              onNoteTap: _showViewSubnotePopup,
                              isUndone: true,
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (provider.yearlyDone.isNotEmpty)
                            _SectionBox(
                              title: 'Done',
                              notes: provider.yearlyDone,
                              provider: provider,
                              onNoteTap: _showViewSubnotePopup,
                              isUndone: false,
                            ),
                          if (provider.yearlyUndone.isEmpty &&
                              provider.yearlyDone.isEmpty)
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
// SECTION BOX WIDGET
// ─────────────────────────────────────
class _SectionBox extends StatelessWidget {
  final String title;
  final List<Note> notes;
  final NoteProvider provider;
  final Function(Note) onNoteTap;
  final bool isUndone;

  const _SectionBox({
    required this.title,
    required this.notes,
    required this.provider,
    required this.onNoteTap,
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
          ...notes.map((note) => _NoteRow(
                note: note,
                provider: provider,
                onTap: () => onNoteTap(note),
              )),
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
  final VoidCallback onTap;

  const _NoteRow({
    required this.note,
    required this.provider,
    required this.onTap,
  });

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

          // Note text — tap to view subnote
          Expanded(
            child: GestureDetector(
              onTap: onTap,
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