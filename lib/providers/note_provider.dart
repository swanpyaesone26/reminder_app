import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../models/subnote_model.dart';
import '../services/note_service.dart';

class NoteProvider extends ChangeNotifier {
  final NoteService _service = NoteService();

  // ─────────────────────────────────────
  // STATE
  // ─────────────────────────────────────
  List<Note> _dailyNotes = [];
  List<Note> _monthlyNotes = [];
  List<Note> _yearlyNotes = [];
  List<Subnote> _subnotes = [];
  bool _isLoading = false;

  // ─────────────────────────────────────
  // GETTERS
  // ─────────────────────────────────────
  List<Note> get dailyUndone =>
      _dailyNotes.where((n) => !n.isDone).toList();
  List<Note> get dailyDone =>
      _dailyNotes.where((n) => n.isDone).toList();

  List<Note> get monthlyUndone =>
      _monthlyNotes.where((n) => !n.isDone).toList();
  List<Note> get monthlyDone =>
      _monthlyNotes.where((n) => n.isDone).toList();

  List<Note> get yearlyUndone =>
      _yearlyNotes.where((n) => !n.isDone).toList();
  List<Note> get yearlyDone =>
      _yearlyNotes.where((n) => n.isDone).toList();

  List<Note> get yearlyNotes => _yearlyNotes;
  List<Subnote> get subnotes => _subnotes;

  List<Subnote> subnotesUndone(String noteId) =>
      _subnotes.where((s) => s.noteId == noteId && !s.isDone).toList();
  List<Subnote> subnoteDone(String noteId) =>
      _subnotes.where((s) => s.noteId == noteId && s.isDone).toList();

  bool get isLoading => _isLoading;

  // ─────────────────────────────────────
  // LOAD NOTES
  // ─────────────────────────────────────
  Future<void> loadNotes(String type) async {
    _isLoading = true;
    notifyListeners();

    if (type == 'daily') {
      _dailyNotes = await _service.getNotesByType('daily');
    } else if (type == 'monthly') {
      _monthlyNotes = await _service.getNotesByType('monthly');
    } else if (type == 'yearly') {
      _yearlyNotes = await _service.getNotesByType('yearly');
    }

    _isLoading = false;
    notifyListeners();
  }

  // ─────────────────────────────────────
  // NOTE ACTIONS
  // ─────────────────────────────────────

  // Add note
  Future<void> addNote(Note note) async {
    await _service.addNote(note);
    await loadNotes(note.type);
  }

  // Toggle isDone
  Future<void> toggleNote(Note note) async {
    final updated = note.copyWith(isDone: !note.isDone);
    await _service.updateNote(updated);
    await loadNotes(note.type);
  }

  // Delete note
  Future<void> deleteNote(Note note) async {
    await _service.deleteNote(note.id);
    await loadNotes(note.type);
  }

  // ─────────────────────────────────────
  // SUBNOTE ACTIONS
  // ─────────────────────────────────────

  // Load subnotes for a specific note
  Future<void> loadSubnotes(String noteId) async {
    _subnotes = await _service.getSubnotes(noteId); // Fixed method name
    notifyListeners();
  }

  // Add subnote
  Future<void> addSubnote(Subnote subnote) async {
    await _service.addSubnote(subnote);
    await loadSubnotes(subnote.noteId);
  }

  // Toggle subnote isDone
  Future<void> toggleSubnote(Subnote subnote) async {
    final updated = subnote.copyWith(isDone: !subnote.isDone);
    await _service.updateSubnote(updated);
    await loadSubnotes(subnote.noteId);
  }

  // Delete subnote
  Future<void> deleteSubnote(Subnote subnote) async {
    await _service.deleteSubnote(subnote.id);
    await loadSubnotes(subnote.noteId);
  }
}
