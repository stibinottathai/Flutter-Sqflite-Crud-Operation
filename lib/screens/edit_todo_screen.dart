import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/todo_provider.dart';

class EditTodoScreen extends StatefulWidget {
  const EditTodoScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  }) : super(key: key);
  final String id;
  final String title;
  final String description;
  final String date;

  @override
  State<EditTodoScreen> createState() => _EditTodoScreenState();
}

class _EditTodoScreenState extends State<EditTodoScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _dateController.text = widget.date;
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Todo'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.edit_outlined,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is Title';
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    hintText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.date_range,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.datetime,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Date is Empty';
                    }
                    if (value.length <= 6) {
                      return 'Check Date';
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(width * 0.04),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      borderSide: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2),
                    ),
                    prefixIcon: const Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.multiline,
                  maxLines: 8,
                  minLines: 4,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Description is Empty';
                    }
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(width * 0.6, height * 0.06),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.03),
                  ),
                ),
                onPressed: () async {

                  if (_key.currentState!.validate() == false) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text(
                          'Error',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        content: const Text('Check the inputs'),
                        actions: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Return',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    await todoProvider.updateTitle(
                      widget.id,
                      _titleController.text,
                    );
                    await todoProvider.updateDescription(
                      widget.id,
                      _descriptionController.text,
                    );
                    await todoProvider.updateDate(
                      widget.id,
                      _dateController.text,
                    );

                    Navigator.of(context).pop();
                  }
                },
                child: Text('Edit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
