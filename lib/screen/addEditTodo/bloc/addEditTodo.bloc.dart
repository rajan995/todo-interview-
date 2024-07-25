import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/models/todo.model.dart';
import 'package:todoapp/utility/sqlite.repository.dart';

abstract class AddEditTodoEvent {}

class SubmitAddEditTodoEvent extends AddEditTodoEvent {
  TodoModel todoModel;
  SubmitAddEditTodoEvent({required this.todoModel});
}

abstract class AddEditTodoState {}

class InitialAddEditTodoState extends AddEditTodoState {}

class SubmitAddEditTodoState extends AddEditTodoState {
  bool isLoading;
  TodoModel? todoModel;
  String? msg;
  SubmitAddEditTodoState({required this.isLoading, this.todoModel, this.msg});
}

class AddEditTodoBloc extends Bloc<AddEditTodoEvent, AddEditTodoState> {
  SqliteDBRepository sqliteDBRepo;
  TodoModel? todoModel;

  AddEditTodoBloc({required this.sqliteDBRepo, this.todoModel})
      : super(InitialAddEditTodoState()) {
    on<SubmitAddEditTodoEvent>(
        (SubmitAddEditTodoEvent event, Emitter<AddEditTodoState> state) async {
      emit(SubmitAddEditTodoState(isLoading: true));
      try {
        TodoModel todoModel = event.todoModel;

        if (this.todoModel != null) {
          todoModel.id = this.todoModel!.id;
          todoModel.fireStoreId = this.todoModel!.fireStoreId;

          final result = await sqliteDBRepo.updateTodo(todoModel);
        } else {
          await sqliteDBRepo.addTodo(todoModel);
        }

        emit(SubmitAddEditTodoState(
            isLoading: false, todoModel: todoModel, msg: "save successfully"));
      } catch (err) {
        emit(SubmitAddEditTodoState(isLoading: false, msg: err.toString()));
      }
    });
  }
}
