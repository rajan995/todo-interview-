import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:todoapp/utility/customException.dart';
import 'package:todoapp/utility/firebase.repository.dart';

abstract class SplashEvent {}

class LoginStatusBlocEvent extends SplashEvent {}

abstract class SplashState {}

class InitialBlocState extends SplashState {}

class LoginStatusBlocState extends SplashState {
  String? uuid;
  LoginStatusBlocState(this.uuid);
}

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  FirebaseRepository firebaseRepo;
  SplashBloc({required this.firebaseRepo}) : super(InitialBlocState()) {
    on<LoginStatusBlocEvent>(
        (LoginStatusBlocEvent event, Emitter<SplashState> state) async {
      String? uuid = this.firebaseRepo.loginStatus();
      emit(LoginStatusBlocState(uuid));
    });
  }
}
