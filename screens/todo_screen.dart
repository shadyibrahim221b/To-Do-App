import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/screens/login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../helpers/database_helper.dart';
import 'modeclass.dart';
import 'taskitem.dart';
// ignore: camel_case_types
class Todo_screen extends StatefulWidget{
  const Todo_screen({super.key});

  @override
  State<Todo_screen> createState() => _Todo_screenState();
}

// ignore: camel_case_types
class _Todo_screenState extends State<Todo_screen> {
  TextEditingController taskcontroller=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController dateController=TextEditingController();
  bool checked=false;
  @override
  Widget build(BuildContext context) {
    var sized = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('ToDo app'), centerTitle: true,actions: [Padding(
        padding: const EdgeInsets.all(8.0),
        child:  IconButton(
          onPressed: () async{
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Icon Button Clicked'),
              ),
            );
            await logedOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder:(context) {
            return const Login();
            }));
          },
          icon: const Icon(Icons.logout_outlined),
        ),
      )
      ],
      ),
      body:  Stack(children: [
        Container(
          width: double.infinity,
          height: sized.height,
          decoration: BoxDecoration(
            color: Colors.amber,
            image:DecorationImage(image:AssetImage('assets/images/licensed-image.jpeg'),
            fit: BoxFit.cover
            )
          ),
        ),
        ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          var task = tasks[index];
          return Dismissible(
            key: Key(index.toString()),
            onDismissed: (direction) {
              DatabseHelper.deleteRecord(task.title!);
              log(task.title!);
              log(direction.name);
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
              ),
              margin: EdgeInsets.all(10),
              color: Colors.blue,
              shadowColor: Colors.blueGrey,
              elevation: 10,
              child: Container(
                padding:EdgeInsets.all(10),
                child: Taskitem(taskDate: task.date!, taskTitle: task.title!, taskDesciption: task.description!,task:task,)
              ),
            ),
          );
        },
      ),

      ],),
      floatingActionButton: FloatingActionButton(onPressed:() {
        showModalBottomSheet(context: context, builder:(context) {
          return Container(
            color: Colors.white,
            child: Column(
            mainAxisSize: MainAxisSize.min,  
            children: [
              Container(
                child: TextField(
                  controller: taskcontroller,
                  textAlign:TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Enter the task',
                    hintText:  'Enter the task'
                  ),
                ),
              ),
              Container(
                child: TextField(
                  controller: descriptionController,
                  textAlign:TextAlign.center,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Enter the description',
                    hintText:  'Enter the description'
                  ),
                ),
              ),
              TextField(
                controller: dateController,
              decoration: const InputDecoration( 
                icon: Icon(Icons.calendar_today),
                labelText: "Enter Date" 
                ),
              readOnly: true,
              onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                       initialDate: DateTime.now(),
                      firstDate:DateTime(2000),
                      lastDate: DateTime(2101)
                  );
                  if(pickedDate != null ){  
                      String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
                      setState(() {
                         dateController.text = formattedDate; 
                      });
                  }else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("Date is not selected"),
                      duration: Duration(seconds: 3),
                      ));
                  }
                }
            ),
                ElevatedButton(onPressed:() {
                  setState(() {
                    var task = Task(title:taskcontroller.text,date: dateController.text,description: descriptionController.text);
                    tasks.add(task);
                    DatabseHelper.insertRow(task);
                    taskcontroller.text='';
                    dateController.text='';
                    descriptionController.text='';
                  }
                  );
                  Navigator.pop(context);
                }, child: Text('Save')
                )

            ],),
            );
        },
        enableDrag: false
        );
      },child: Icon(Icons.add_outlined),),
    );
  }
  logedOut() async{
    SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
   await sharedPrefs.setBool('isLogedIn', false);
  }
}