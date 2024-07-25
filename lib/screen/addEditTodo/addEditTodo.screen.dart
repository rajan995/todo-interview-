import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/models/todo.model.dart';
import 'package:todoapp/screen/addEditTodo/bloc/addEditTodo.bloc.dart';
import 'package:todoapp/utility/sqlite.repository.dart';
import 'package:todoapp/utility/utility.dart';

class AddEditTodoScreen extends StatefulWidget {
  TodoModel? todoModel;
  AddEditTodoScreen({this.todoModel});
  @override
  State<StatefulWidget> createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  Widget _bloc({required Widget child}) {
    return BlocProvider<AddEditTodoBloc>(
        create: (context) => AddEditTodoBloc(
            sqliteDBRepo: context.read<SqliteDBRepository>(),
            todoModel: widget.todoModel),
        child: child);
  }

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController dueDate = TextEditingController();
  final _key = GlobalKey<FormState>();
  String? priorityLevel;
  List<String> priorityLevels = ['p1', 'p2', 'p3'];

  @override
  initState() {
    if (widget.todoModel != null) {
      title.text = widget.todoModel!.title;
      description.text = widget.todoModel!.description;
      dueDate.text = widget.todoModel!.dueDate;
      priorityLevel = widget.todoModel!.priorityLevel;
    }
  }

  Widget build(BuildContext context) {
    return _bloc(
        child: Scaffold(
            appBar: AppBar(
              title: Text(widget.todoModel != null ? "Edit Todo" : "Add Todo"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Form(
                key: _key,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Title"),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: title,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please enter Title';
                          }
                        },
                        decoration:
                            InputDecoration(hintText: "Please enter title"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Description"),
                      SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: description,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          } else {
                            return 'Please enter Description';
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Please enter Description"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Due Date"),
                      InkWell(
                        onTap: () async {
                          DateTime? date = await Utility.datePicker(
                              context, DateTime.tryParse(dueDate.text));
                          if (date != null) {
                            dueDate.text =
                                date.toString().substring(0, 10).trim();
                          }
                        },
                        child: IgnorePointer(
                          child: TextFormField(
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please select Due Date';
                              }
                            },
                            controller: dueDate,
                            decoration: InputDecoration(hintText: "Date"),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Priority Level"),
                      SizedBox(
                          width: double.infinity,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value != null && value.isNotEmpty) {
                                return null;
                              } else {
                                return 'Please select Priority Level';
                              }
                            },
                            padding: EdgeInsets.only(left: 10),
                            isExpanded: true,
                            style: TextStyle(color: Colors.black),
                            value: priorityLevel,
                            items: [
                              ...priorityLevels!.map((d) =>
                                  DropdownMenuItem(child: Text(d), value: d))
                            ],
                            onChanged: (value) {
                              priorityLevel = value;
                              setState(() {});
                            },
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: BlocConsumer<AddEditTodoBloc, AddEditTodoState>(
                          listener: (BuildContext context, Object? state) {
                            if (state is SubmitAddEditTodoState &&
                                state.msg != null) {
                              Utility.toastMessage(context, state.msg!);
                            }
                            if (state is SubmitAddEditTodoState &&
                                state.todoModel != null) {
                              Navigator.of(context).pop();
                            }
                          },
                          builder: (BuildContext context, state) {
                            if (state is SubmitAddEditTodoState &&
                                state.isLoading) {
                              return ElevatedButton(
                                  onPressed: null,
                                  child: CircularProgressIndicator());
                            }

                            return ElevatedButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  TodoModel todoModel = TodoModel(
                                      title: title.text,
                                      description: description.text,
                                      dueDate: dueDate.text,
                                      priorityLevel: priorityLevel!);
                                  context.read<AddEditTodoBloc>().add(
                                      SubmitAddEditTodoEvent(
                                          todoModel: todoModel));
                                }
                              },
                              child: Text("Submit"),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
