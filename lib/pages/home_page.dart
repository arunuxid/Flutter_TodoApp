import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import '../Util/todo_tile.dart';
import '../Util/dialog_box.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  // reference hive box
  final _mybox = Hive.box('mybox');
  ToDoDatabase db = ToDoDatabase();

  @override
  void initState(){
    //if this is the first time opening the app then create default data
    if(_mybox.get("TODOLIST") == null ){
      db.createInitialData();
    } else {
      // the user is not first time opening
      db.loadData();
    }

    super.initState();
  }

  // text controller
  final _controller = TextEditingController();

  // Function to change the state of checkbox
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  //Function to create a new task
  void createNewTask() {
    showDialog(
      context: context, 
      builder: (context) {
        return DialogBox(
          controller: _controller, 
          onSave: saveNewTask, 
          onCancel: () => Navigator.of(context).pop());
      },
    );
  }

  // Function to delete a task
  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: Colors.yellow[200],
      
      appBar: AppBar(
        title: Text('To Do'),
        backgroundColor: Colors.yellow[400],
        elevation: 0,
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createNewTask();
        },
        child: Icon(Icons.add),
      ),
      
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index){
          return TodoTile(
            taskName: db.toDoList[index][0], 
            taskCompleted: db.toDoList[index][1], 
            onChanged:(value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      )
    );
  }
}