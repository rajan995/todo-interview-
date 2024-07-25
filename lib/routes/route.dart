import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.model.dart';
import 'package:todoapp/screen/addEditTodo/addEditTodo.screen.dart';
import 'package:todoapp/screen/home/home.screen.dart';
import 'package:todoapp/screen/login/login.screen.dart';
import 'package:todoapp/screen/signup/signup.screen.dart';
import 'package:todoapp/screen/splash/splash.screen.dart';

Route<dynamic>? onGenerateRoute(RouteSettings setting) {
  switch (setting.name) {
    case '/':
      {
        return MaterialPageRoute(builder: (_) => SplashScreen());
      }
    case '/login':
      {
        return MaterialPageRoute(builder: (_) => LoginScreen());
      }
    case '/signup':
      {
        return MaterialPageRoute(builder: (_) => SignupScreen());
      }
    case '/home':
      {
        return MaterialPageRoute(builder: (_) => HomeScreen());
      }
    case '/addEditTodo':
      {
        return MaterialPageRoute(
            builder: (_) => AddEditTodoScreen(
                  todoModel: setting.arguments as TodoModel?,
                ));
      }
  }
}
