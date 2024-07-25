import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:todoapp/utility/customException.dart';
import 'package:todoapp/utility/firebase.repository.dart';

abstract class SignupEvent {}

class SubmitSignupEvent extends SignupEvent {
  String email;
  String password;
  SubmitSignupEvent({required this.email, required this.password});
}

abstract class SignupState {}

class InitialSignupState extends SignupState {}

class SubmitSignupState extends SignupState {
  String? msg;
  bool isLoading;
  UserCredential? credential;
  SubmitSignupState({this.msg, required this.isLoading, this.credential});
}

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  FirebaseRepository firebaseRepo;
  SignupBloc({required this.firebaseRepo}) : super(InitialSignupState()) {
    on<SubmitSignupEvent>(
        (SubmitSignupEvent event, Emitter<SignupState> state) async {
      emit(SubmitSignupState(isLoading: true));
      try {
        UserCredential? credencial = await firebaseRepo.signUp(
            email: event.email, password: event.password);
        emit(SubmitSignupState(
            isLoading: false,
            msg: "Signup Successfully",
            credential: credencial));
      } on CustomException catch (err) {
        emit(SubmitSignupState(isLoading: false, msg: err.msg));
      }
    });
  }
}
