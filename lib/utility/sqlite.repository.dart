import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/models/todo.model.dart';

class SqliteDBRepository {
  Future<String> getDbPath() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'todo010009901.db');
    return path;
  }

  Future<Database> createToDoTableIfNotExist() async {
    String path = await getDbPath();
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS Todo (id INTEGER PRIMARY KEY, title TEXT, description TEXT, dueDate TEXT, complete BOOLEAN, priorityLevel TEXT, fireStoreId TEXT, localDelete BOOLEAN )');
    });
    return database;
  }

  Future<int?> addTodo(TodoModel todoModel) async {
    final database = await createToDoTableIfNotExist();
    int? id;
    await database.transaction((txn) async {
      id = await txn.rawInsert(
          "INSERT INTO Todo(title, description, dueDate, complete, priorityLevel, localDelete) VALUES ('${todoModel.title}', '${todoModel.description}', '${todoModel.dueDate}', '${todoModel.complete.toString()}', '${todoModel.priorityLevel}', '${todoModel.localDelete.toString()}')");
    });
    await database.close();
    return id;
  }

  Future<int?> updateTodo(TodoModel todoModel) async {
    final database = await createToDoTableIfNotExist();

    int count = await database.rawUpdate(
        "UPDATE Todo SET title = ?, description = ?, dueDate = ?, complete = ?, priorityLevel = ?, fireStoreId = ?, localDelete = ?  WHERE id = '${todoModel.id}'",
        [
          todoModel.title,
          todoModel.description,
          todoModel.dueDate,
          todoModel.complete.toString(),
          todoModel.priorityLevel,
          todoModel.fireStoreId,
          todoModel.localDelete.toString()
        ]);
    await database.close();
    return count;
  }

  Future<int?> deleteTodo(TodoModel todoModel) async {
    final database = await createToDoTableIfNotExist();
    final count = await database
        .rawDelete('DELETE FROM Todo WHERE id = ?', [todoModel.id]);

    await database.close();
    return count;
  }

  Future<List<TodoModel>> getTodos() async {
    final database = await createToDoTableIfNotExist();
    List<Map> list = await database.rawQuery("SELECT * FROM Todo");

    List<TodoModel> todoModelList = list
        .cast<Map<String, dynamic>>()
        .map<TodoModel>((d) => TodoModel.fromJson(d))
        .toList();
    print(todoModelList);
    await database.close();
    return todoModelList;
  }
}
