part of 'note_bloc.dart';

sealed class NoteEvent{
  const NoteEvent();
}

class LoadNotes extends NoteEvent {}

class AddNewNote extends NoteEvent {
  final Note note;

  const AddNewNote(this.note);
}

class UpdateExistingNote extends NoteEvent {
  final Note note;

  const UpdateExistingNote(this.note);
}

class DeleteExistingNote extends NoteEvent {
  final String id;

  const DeleteExistingNote(this.id);

}

class SearchNotes extends NoteEvent{
  final String query;

  const SearchNotes(this.query);
}