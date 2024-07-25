import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/screen/login/bloc/login.bloc.dart';
import 'package:todoapp/utility/firebase.repository.dart';
import 'package:todoapp/utility/utility.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreen extends StatelessWidget {
  Widget _bloc({required Widget child}) {
    return BlocProvider<LoginBloc>(
        create: (context) =>
            LoginBloc(firebaseRepo: context.read<FirebaseRepository>()),
        child: child);
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final _key = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return _bloc(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _key,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 70),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Email "),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: email,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value != null) {
                        if (EmailValidator.validate(value)) {
                          return null;
                        } else {
                          return 'Please enter valid email';
                        }
                      } else {
                        return 'Please enter email';
                      }
                    },
                    decoration: InputDecoration(hintText: "example@gmail.com"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Password"),
                  SizedBox(
                    height: 5,
                  ),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        return null;
                      } else {
                        return 'Please enter password';
                      }
                    },
                    decoration: InputDecoration(hintText: "xxxxx"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: BlocConsumer<LoginBloc, LoginState>(
                        listener: (context, state) {
                          if (state is SubmitLoginState && state.msg != null) {
                            Utility.toastMessage(context, state.msg!);
                          }
                          if (state is SubmitLoginState &&
                              state.credential != null) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (routes) => false);
                          }
                        },
                        builder: (BuildContext context, state) {
                          if (state is SubmitLoginState && state.isLoading) {
                            return const ElevatedButton(
                                onPressed: null,
                                child: CircularProgressIndicator());
                          }
                          return ElevatedButton(
                              onPressed: () {
                                if (_key.currentState!.validate()) {
                                  context.read<LoginBloc>().add(
                                      SubmitLoginEvent(
                                          email: email.text,
                                          password: password.text));
                                }
                              },
                              child: Text("Login"));
                        },
                      )),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?"),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/signup', (route) => false);
                          },
                          child: Text(
                            "Sign Up now",
                            style: TextStyle(color: Colors.red),
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
