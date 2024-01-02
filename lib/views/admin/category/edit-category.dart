import 'package:flutter/material.dart';

class EditCategoryDialog extends StatefulWidget {
  final String categoryName;
  final String categoryDescription;
  final List<String> categoryImageUrl;

  EditCategoryDialog({
    required this.categoryName,
    required this.categoryDescription,
    required this.categoryImageUrl,
  });

  @override
  _EditCategoryDialogState createState() => _EditCategoryDialogState();
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.categoryName);
    _descriptionController = TextEditingController(text: widget.categoryDescription);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Edit Category"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: "Description"),
          ),
          // Add other fields or widgets as needed...
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            // Save the changes
            Navigator.of(context).pop(true);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
