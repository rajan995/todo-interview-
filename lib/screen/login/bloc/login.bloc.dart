import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:todoapp/utility/customException.dart';
import 'package:todoapp/utility/firebase.repository.dart';

abstract class LoginEvent {}

class SubmitLoginEvent extends LoginEvent {
  String email;
  String password;
  SubmitLoginEvent({required this.email, required this.password});
}

abstract class LoginState {}

class InitialLoginState extends LoginState {}

class SubmitLoginState extends LoginState {
  String? msg;
  bool isLoading;
  UserCredential? credential;
  SubmitLoginState({this.msg, required this.isLoading, this.credential});
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  FirebaseRepository firebaseRepo;
  LoginBloc({required this.firebaseRepo}) : super(InitialLoginState()) {
    on<SubmitLoginEvent>(
        (SubmitLoginEvent event, Emitter<LoginState> state) async {
      emit(SubmitLoginState(isLoading: true));
      try {
        UserCredential? credencial = await firebaseRepo.signIn(
            email: event.email, password: event.password);
        emit(SubmitLoginState(
            isLoading: false,
            msg: "Login Successfully",
            credential: credencial));
      } on CustomException catch (err) {
        emit(SubmitLoginState(isLoading: false, msg: err.msg));
      }
    });
  }
}
