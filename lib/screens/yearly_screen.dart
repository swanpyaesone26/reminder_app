import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../models/subnote_model.dart';
import '../providers/note_provider.dart';

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
                  controller: noteController,
                  style: GoogleFonts.caveat(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subnote field (optional)
              Text(
                'Sub-Note (Optional)',
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
                  controller: subnoteController,
                  style: GoogleFonts.caveat(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  maxLines: 2,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

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

                    // Add subnote if filled
                    if (subnoteController.text.trim().isNotEmpty) {
                      final subnote = Subnote(
                        noteId: note.id,
                        text: subnoteController.text.trim(),
                      );
                      await context.read<NoteProvider>().addSubnote(subnote);
                    }

                    if (context.mounted) Navigator.pop(context);
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
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Colors.white, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main note
                  Row(
                    children: [
                      const Icon(Icons.notes, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          note.text,
                          style: GoogleFonts.caveat(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white38, height: 24),

                  // Subnote
                  Text(
                    'Sub-Note',
                    style: GoogleFonts.caveat(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  subnotes.isEmpty
                      ? Text(
                    'No sub-note added',
                    style: GoogleFonts.caveat(
                      color: Colors.white38,
                      fontSize: 16,
                    ),
                  )
                      : Text(
                    subnotes.first.text,
                    style: GoogleFonts.caveat(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Close button
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text(
                        'Close',
                        style: GoogleFonts.caveat(
                          color: Colors.white60,
                          fontSize: 18,
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
                    'Yearly Plan',
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
                    if (provider.yearlyUndone.isNotEmpty) ...[
                      _SectionBox(
                        title: 'Undone',
                        notes: provider.yearlyUndone,
                        provider: provider,
                        onNoteTap: _showViewSubnotePopup,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Done section
                    if (provider.yearlyDone.isNotEmpty)
                      _SectionBox(
                        title: 'Done',
                        notes: provider.yearlyDone,
                        provider: provider,
                        onNoteTap: _showViewSubnotePopup,
                      ),

                    // Empty state
                    if (provider.yearlyUndone.isEmpty &&
                        provider.yearlyDone.isEmpty)
                      Center(
                        child: Text(
                          'No notes yet',
                          style: GoogleFonts.caveat(
                            color: Colors.white38,
                            fontSize: 20,
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

  const _SectionBox({
    required this.title,
    required this.notes,
    required this.provider,
    required this.onNoteTap,
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

          // Note text — tap to view subnote
          Expanded(
            child: GestureDetector(
              onTap: onTap,
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