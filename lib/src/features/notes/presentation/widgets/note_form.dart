import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noteapp/src/features/notes/domain/entity/note.dart';
import 'package:noteapp/src/features/notes/presentation/bloc/note_bloc.dart';
import 'package:uuid/uuid.dart';


class NoteForm extends StatefulWidget {
  final Note? note;

  const NoteForm({super.key, this.note});

  @override
  State<NoteForm> createState() => _NoteFormState();
}

class _NoteFormState extends State<NoteForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add/Edit Note')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _title,
                        decoration: const InputDecoration(
                            labelText: 'Title',
                            border: OutlineInputBorder()
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => _title = value!,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        initialValue: _content,
                        maxLines: 18,
                        decoration: const InputDecoration(
                            labelText: 'Content',
                            border: OutlineInputBorder(),
                            alignLabelWithHint: true,
                        ),
                        validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
                        onSaved: (value) => _content = value!,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final note = Note(
                        id: widget.note?.id ?? const Uuid().v4(),
                        title: _title,
                        content: _content,
                        createdAt: widget.note?.createdAt ?? DateTime.now(),
                      );
                      if (widget.note == null) {
                        BlocProvider.of<NoteBloc>(context).add(AddNewNote(note));
                      } else {
                        BlocProvider.of<NoteBloc>(context).add(UpdateExistingNote(note));
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}