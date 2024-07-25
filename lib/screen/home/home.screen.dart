import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/screen/home/bloc/home.bloc.dart';
import 'package:todoapp/screen/home/drawer.screen.dart';
import 'package:todoapp/utility/firebase.repository.dart';
import 'package:todoapp/utility/firestore.repository.dart';
import 'package:todoapp/utility/sqlite.repository.dart';
import 'package:todoapp/utility/utility.dart';

class HomeScreen extends StatelessWidget {
  Widget _bloc({required Widget child}) {
    return BlocProvider<HomeBloc>(
        create: (context) => HomeBloc(
            sqliteDBRepo: context.read<SqliteDBRepository>(),
            firestoreRepo: context.read<FirestoreRepository>(),
            firebaseRepo: context.read<FirebaseRepository>())
          ..add(FetchDataHomeEvent()),
        child: child);
  }

  Widget build(BuildContext context) {
    return _bloc(
      child: BlocConsumer<HomeBloc, HomeState>(listener: (context, state) {
        if (state is LogoutHomeState) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/login', (route) => false);
        }
        if (state is fetchDataHomeState && state.msg != null) {
          Utility.toastMessage(context, state.msg!);
        }
      }, builder: (BuildContext context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Todo App"),
              actions: [
                (state is fetchDataHomeState && state.syncLoading == true)
                    ? IconButton(
                        onPressed: null, icon: CircularProgressIndicator())
                    : IconButton(
                        onPressed: () =>
                            context.read<HomeBloc>().add(SyncDataHomeEvent()),
                        icon: Icon(Icons.sync))
              ],
              centerTitle: true,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/addEditTodo').then((_) {
                  context.read<HomeBloc>().add(FetchDataHomeEvent());
                });
              },
              child: const Icon(Icons.add),
            ),
            drawer: DrawerScreen(),
            body: RefreshIndicator(
              onRefresh: () async {
                context.read<HomeBloc>().add(FetchDataHomeEvent());
              },
              child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (BuildContext context, state) {
                if (state is fetchDataHomeState &&
                    state.todoList != null &&
                    state.todoList!
                        .where((d) => d.localDelete != true)
                        .isEmpty) {
                  return Center(
                    child: Text("Please add Todo"),
                  );
                }
                if (state is fetchDataHomeState && state.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is fetchDataHomeState &&
                    state.todoList != null &&
                    state.todoList!.isNotEmpty) {
                  return ListView(
                    padding: EdgeInsets.all(10),
                    children: [
                      ...state.todoList!
                          .where((d) => d.localDelete != true)
                          .map((data) {
                        return Card(
                          color: data.complete == true
                              ? Colors.blue[50]
                              : Colors.white,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  title: Text("Title : " + data.title),
                                  subtitle:
                                      Text("Description : " + data.description),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushNamed('/addEditTodo',
                                                    arguments: data)
                                                .then((_) {
                                              context
                                                  .read<HomeBloc>()
                                                  .add(FetchDataHomeEvent());
                                            });
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            context.read<HomeBloc>().add(
                                                DeleteRecordHomeEvent(
                                                    todoModel: data));
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  )),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("Complete Task :"),
                                    Switch(
                                      value: data.complete,
                                      activeColor: Colors.blue,
                                      onChanged: (bool value) {
                                        data.complete = value;
                                        context.read<HomeBloc>().add(
                                            CompleteStatusHomeEvent(
                                                todoModel: data));
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      })
                    ],
                  );
                }
                return Center(child: Text("do not have any Todo task"));
              }),
            ));
      }),
    );
  }
}
