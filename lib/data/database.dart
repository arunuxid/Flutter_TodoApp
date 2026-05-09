import "package:hive_flutter/hive_flutter.dart";

class ToDoDatabase {

  List toDoList = [];

  // reference box
  final _mybox = Hive.box('mybox');

  // first time opening the app. DUmmy data
  void createInitialData() {
    toDoList = [
      ['Make Tutorial', false],
      ["Do Exercise", false]
    ];
  }

  // Load the data from the databse
  void loadData(){
    toDoList = _mybox.get('TODOLIST');
  }

  // Update the data from the db
  void updateDataBase(){
    _mybox.put("TODOLIST", toDoList);
  }

}