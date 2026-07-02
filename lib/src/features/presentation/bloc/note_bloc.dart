import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/features/domain/entity/note.dart';
import 'package:noteapp/src/features/domain/usecase/add_note_usecase.dart';
import 'package:noteapp/src/features/domain/usecase/delete_note_usecase.dart';
import 'package:noteapp/src/features/domain/usecase/get_notes_usecase.dart';
import 'package:noteapp/src/features/domain/usecase/update_note_usecase.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final AddNoteUsecase addNote;
  final DeleteNoteUsecase deleteNote;
  final GetNotesUsecase getNotes;
  final UpdateNoteUsecase updateNote;

  NoteBloc({
    required this.addNote,
    required this.deleteNote,
    required this.getNotes,
    required this.updateNote,
  }) : super(NoteInitial()) {
    on<LoadNotes>(_onLoadNotes);
    on<AddNewNote>(_onAddNote);
    on<UpdateExistingNote>(_onUpdateNote);
    on<DeleteExistingNote>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(
      LoadNotes event,
      Emitter<NoteState> emit,
      ) async {
    emit(NoteLoading());

    final result = await getNotes();

    result.fold(
          (failure) => emit(NoteError(failure.message)),
          (notes) => emit(NoteLoaded(notes: notes)),
    );
  }

  Future<void> _onAddNote(
      AddNewNote event,
      Emitter<NoteState> emit,
      ) async {
    final result = await addNote(event.note);

    result.fold(
          (failure) => emit(NoteError(failure.message)),
          (_) => add(LoadNotes()),
    );
  }

  Future<void> _onUpdateNote(
      UpdateExistingNote event,
      Emitter<NoteState> emit,
      ) async {
    final result = await updateNote(event.note);

    result.fold(
          (failure) => emit(NoteError(failure.message)),
          (_) => add(LoadNotes()),
    );
  }

  Future<void> _onDeleteNote(
      DeleteExistingNote event,
      Emitter<NoteState> emit,
      ) async {
    final result = await deleteNote(event.id);

    result.fold(
          (failure) => emit(NoteError(failure.message)),
          (_) => add(LoadNotes()),
    );
  }
}