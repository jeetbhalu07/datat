//Main.dart

import 'dart:io';
import 'dart:math';

import 'package:external_path/external_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_demo/view_data.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

void main()
{
    runApp(MaterialApp(home: first(),));
}
class first extends StatefulWidget {
  const first({super.key});
  static Database ?database;
  static Directory ?dir;

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  TextEditingController t4=TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String gen="";
  String city="surat";
  bool t=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();
    data();
  }
  get()
  async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.location,
        Permission.storage,
      ].request();
    }
    var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)+"/img";
    print(path);

    first. dir=Directory(path);
    if(! await  first.dir!.exists())
      {
          first. dir!.create();
      }

  }
  data()
  async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');

    first. database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE students (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT,contact TEXT,email TEXT,password TEXT, gender TEXT,city TEXT,image TEXT)');
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: Column(
        children: [
          TextField(
            controller: t1,
          ),
          TextField(
            controller: t2,
          ),
          TextField(
            controller: t3,
          ),
          TextField(
            controller: t4,
          ),
          Row(
            children: [
              Radio(value: "Male", groupValue: gen, onChanged: (value) {
                      gen=value!;
                      setState(() {

                      });
              },),
              Text("Male"),
              Radio(value: "Female", groupValue: gen, onChanged: (value) {
                gen=value!;
                setState(() {

                });
              },),
              Text("Female")
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: city,

                items: [
                DropdownMenuItem(child: Text("Surat"),value: "surat",),
                DropdownMenuItem(child: Text("Rajkot"),value: "Rajkot",),
                DropdownMenuItem(child: Text("Vapi"),value: "Vapi",),
              ], onChanged: (value) {
                 city=value.toString();
                 setState(() {

                 });
              },)
            ],
          ),
          Row(
            children: [
              ElevatedButton(onPressed: () {
                    showDialog(context: context, builder: (context) {
                       return AlertDialog(
                         title: Text("Choose any one"),
                         actions: [
                           TextButton(onPressed: () async {
                             image = await picker.pickImage(source: ImageSource.camera);
                             t=true;
                             Navigator.pop(context);
                             setState(() {

                             });
                           }, child: Text("Camera")),
                           TextButton(onPressed: () async {
                             image = await picker.pickImage(source: ImageSource.gallery);
                             t=true;
                             Navigator.pop(context);
                             setState(() {

                             });
                           }, child: Text("Gellery"))
                         ],
                       );
                    },);
              }, child: Text("Choose")),
              Container(
                height: 100,
                width: 100,
                color: Colors.yellow,
                child: (t)?Image.file(File(image!.path)):null,
              )
            ],
          ),
          ElevatedButton(onPressed: () async {

             String name=t1.text;
             String contact=t2.text;
             String email=t3.text;
             String password=t4.text;


             int r=Random().nextInt(100);
             String img_name="${r}.png";
             File f=File("${first.dir!.path}/${img_name}");
             f.writeAsBytes( await image!.readAsBytes());





             String sql="insert into students values(null,'$name','$contact','$email','$password','$gen','$city','$img_name')";
                first.database!.rawInsert(sql);
                print(sql);
                setState(() {

                });







          }, child: Text("ADD")),
          ElevatedButton(onPressed:  () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
               return view_data();
            },));
          }, child: Text("View"))

        ],
      ),
    );
  }
}
