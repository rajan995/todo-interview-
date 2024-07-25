import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/screen/splash/bloc/splash.bloc.dart';
import 'package:todoapp/utility/firebase.repository.dart';

class SplashScreen extends StatelessWidget {
  Widget _bloc({required Widget child}) {
    return BlocProvider<SplashBloc>(
        create: (context) =>
            SplashBloc(firebaseRepo: context.read<FirebaseRepository>())
              ..add(LoginStatusBlocEvent()),
        child: child);
  }

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _bloc(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Splash"),
        ),
        body: BlocListener<SplashBloc, SplashState>(
          listener: (context, state) {
            if (state is LoginStatusBlocState && state.uuid != null) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/home", (route) => false);
            }
            if (state is LoginStatusBlocState && state.uuid == null) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("/login", (route) => false);
            }
          },
          child: Center(
            child: Text("Todo App"),
          ),
        ),
      ),
    );
  }
}
