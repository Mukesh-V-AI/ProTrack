import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/data_provider.dart';

class AddLeetCodeDialog extends StatefulWidget {
  const AddLeetCodeDialog({super.key});

  @override
  State<AddLeetCodeDialog> createState() => _AddLeetCodeDialogState();
}

class _AddLeetCodeDialogState extends State<AddLeetCodeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _problemsController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _problemsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final problems = int.tryParse(_problemsController.text) ?? 0;
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();

      Provider.of<DataProvider>(context, listen: false).addLeetCodeEntry(
        problems,
        notes: notes,
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add LeetCode Entry'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _problemsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Problems Solved',
                  prefixIcon: Icon(Icons.numbers),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter number of problems';
                  }
                  final num = int.tryParse(value);
                  if (num == null || num < 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: Icon(Icons.note_outlined),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

