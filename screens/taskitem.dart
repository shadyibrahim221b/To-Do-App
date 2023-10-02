import 'package:flutter/material.dart';
import 'package:flutter_application_1/ToDo%20app/screens/modeclass.dart';
import 'package:intl/intl.dart';
import 'dart:developer';
import '../../helpers/database_helper.dart';

class  Taskitem extends StatefulWidget{
  String taskDate;
  String taskTitle;
  String taskDesciption;
  Task task;

  Taskitem({super.key,required this.taskDate,required this.taskTitle,required this.taskDesciption,required this.task});

  @override
  State<Taskitem> createState() => _TaskitemState();
}

class _TaskitemState extends State<Taskitem> {
  TextEditingController taskcontroller=TextEditingController();
  TextEditingController descriptionController=TextEditingController();
  TextEditingController dateController=TextEditingController();

  @override
  Widget build(BuildContext context) {
     String odlTitle;
    return 
      Row(children: [
            SizedBox(width: 8,),
            CircleAvatar(
            radius: 50.0,
            child: ClipRRect(
            child:Text(widget.taskDate),
            borderRadius: BorderRadius.circular(100.0),
            ),
            ),
            SizedBox(width: 8,),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Title(color:Colors.blue, child:Text(widget.taskTitle,style: TextStyle(fontSize:20,color: Colors.white),)),
                  SizedBox(height: 8,),
                Container(
                  width: 150,
                  child: Text(widget.taskDesciption,style: TextStyle(fontSize: 15,color:Colors.black),overflow: TextOverflow.ellipsis,
                maxLines: 100,))
              ],),
            ),
            ElevatedButton(onPressed:() {
              showBottomSheet(context: context, builder:(context) {
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
                odlTitle=widget.task.title!;
                widget.task.title=taskcontroller.text;
                widget.task.description=descriptionController.text;
                widget.task.date=dateController.text;
               DatabseHelper.updateRecord(widget.task,odlTitle);
                });
                Navigator.pop(context); 
              },
              child: Text('Update'))
                    ],
                  ),
                );
              },
              );
            },
            child: Text('Update'), )

        ],);
    
  }
}