import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todoapp/models/todo.model.dart';

class FirestoreRepository {
  CollectionReference todoFireStore =
      FirebaseFirestore.instance.collection('todo');

  Future<String?> addTodo(TodoModel todoModel) async {
    final collectionRef = await todoFireStore.add(todoModel.toJson());
    return collectionRef.id;
  }

  Future<void> updateTodo(TodoModel todoModel) async {
    await todoFireStore.doc(todoModel.fireStoreId).update(todoModel.toJson());
  }

  Future<void> deleteTodo(TodoModel todoModel) async {
    await todoFireStore.doc(todoModel.fireStoreId).delete();
  }
}
