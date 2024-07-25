class TodoModel {
  int? id;
  String title;
  String description;
  String dueDate;
  bool complete;
  String priorityLevel;
  String? fireStoreId;
  bool? localDelete;
  TodoModel(
      {this.id,
      required this.title,
      required this.description,
      required this.dueDate,
      this.complete = false,
      this.localDelete = false,
      required this.priorityLevel,
      this.fireStoreId});

  factory TodoModel.fromJson(Map<String, dynamic> map) {
    return TodoModel(
        id: map['id'],
        title: map['title'],
        fireStoreId: map['fireStoreId'],
        localDelete: bool.parse(map['localDelete']),
        description: map['description'],
        complete: bool.parse(map['complete']),
        dueDate: map['dueDate'],
        priorityLevel: map['priorityLevel']);
  }
  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "complete": complete.toString(),
      "dueDate": dueDate,
      "priorityLevel": priorityLevel
    };
  }
}
