import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/models/todo.model.dart';
import 'package:todoapp/utility/firebase.repository.dart';
import 'package:todoapp/utility/firestore.repository.dart';
import 'package:todoapp/utility/sqlite.repository.dart';
import 'package:todoapp/utility/utility.dart';

abstract class HomeEvent {}

class FetchDataHomeEvent extends HomeEvent {}

class SyncDataHomeEvent extends HomeEvent {}

class LogoutHomeEvent extends HomeEvent {}

class DeleteRecordHomeEvent extends HomeEvent {
  TodoModel todoModel;
  DeleteRecordHomeEvent({required this.todoModel});
}

class CompleteStatusHomeEvent extends HomeEvent {
  TodoModel todoModel;
  CompleteStatusHomeEvent({required this.todoModel});
}

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LogoutHomeState extends HomeState {}

class fetchDataHomeState extends HomeState {
  bool isLoading;
  List<TodoModel>? todoList;
  String? msg;
  bool syncLoading = false;
  User? user;
  fetchDataHomeState(
      {required this.isLoading,
      this.todoList,
      this.msg,
      this.syncLoading = false,
      this.user});
}

class SyncDataHomeState extends HomeState {
  bool isLoading;
  SyncDataHomeState({required this.isLoading});
}

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  StreamSubscription<User?>? _authenticationStatusSubscription;
  SqliteDBRepository sqliteDBRepo;
  FirestoreRepository firestoreRepo;
  FirebaseRepository firebaseRepo;
  HomeBloc(
      {required this.sqliteDBRepo,
      required this.firestoreRepo,
      required this.firebaseRepo})
      : super(InitialHomeState()) {
    on<FetchDataHomeEvent>((FetchDataHomeEvent event, state) async {
      emit(fetchDataHomeState(isLoading: true));

      try {
        List<TodoModel> todoList = await sqliteDBRepo.getTodos();
        emit(fetchDataHomeState(isLoading: false, todoList: todoList));
      } catch (err) {
        emit(fetchDataHomeState(isLoading: false));
      }
    });
    on<SyncDataHomeEvent>(
      (SyncDataHomeEvent event, state) async {
        List<TodoModel> todoList = await sqliteDBRepo.getTodos();
        emit(fetchDataHomeState(
            isLoading: false,
            syncLoading: true,
            todoList: todoList,
            msg: "Sync Start"));
        todoList.forEach((TodoModel todo) async {
          if (todo.localDelete == true) {
            await sqliteDBRepo.deleteTodo(todo);
            if (todo.fireStoreId != null && todo.fireStoreId!.isNotEmpty) {
              await firestoreRepo.deleteTodo(todo);
            }
          } else if (todo.fireStoreId == null) {
            String? fireStoreId = await firestoreRepo.addTodo(todo);
            todo.fireStoreId = fireStoreId;
            final result = await sqliteDBRepo.updateTodo(todo);
          } else {
            await firestoreRepo.updateTodo(todo);
          }
          List<TodoModel> todoList = await sqliteDBRepo.getTodos();
          emit(fetchDataHomeState(
              isLoading: false,
              syncLoading: false,
              todoList: todoList,
              msg: "Sync Successfully"));
        });
      },
    );

    on<DeleteRecordHomeEvent>((DeleteRecordHomeEvent event, state) async {
      TodoModel todoModel = event.todoModel;
      todoModel.localDelete = true;
      final result = await sqliteDBRepo.updateTodo(todoModel);
      List<TodoModel> todoList = await sqliteDBRepo.getTodos();
      emit(fetchDataHomeState(
          isLoading: false, todoList: todoList, msg: "Delete Successfully"));
    });
    on<CompleteStatusHomeEvent>((CompleteStatusHomeEvent event, state) async {
      final result = await sqliteDBRepo.updateTodo(event.todoModel);
      List<TodoModel> todoList = await sqliteDBRepo.getTodos();
      emit(fetchDataHomeState(isLoading: false, todoList: todoList));
    });
    on<LogoutHomeEvent>((LogoutHomeEvent event, state) {
      emit(LogoutHomeState());
    });
    this._authenticationStatusSubscription =
        firebaseRepo.instance.authStateChanges().listen((d) {
      if (d == null) {
        add(LogoutHomeEvent());
      }
    });
  }
  @override
  Future<void> close() {
    if (_authenticationStatusSubscription != null) {
      _authenticationStatusSubscription!.cancel();
    }
    return super.close();
  }
}
