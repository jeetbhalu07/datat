// edit

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:offline_demo/main.dart';
import 'package:offline_demo/view_data.dart';

class edit_data extends StatefulWidget {
  Map l;
  edit_data(this.l);


  @override
  State<edit_data> createState() => _edit_dataState();
}

class _edit_dataState extends State<edit_data> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  TextEditingController t3=TextEditingController();
  TextEditingController t4=TextEditingController();
  final ImagePicker picker = ImagePicker();
  XFile? image;
  String gen="";
  String city="surat";
  bool t=false;
  File ?file;
  
  String new_img="";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if(widget.l!=null)
      {
          t1.text=widget.l['name'];
          t2.text=widget.l['contact'];
          t3.text=widget.l['email'];
          t4.text=widget.l['password'];
          gen=widget.l['gender'];
          city=widget.l['city'];
          new_img=widget.l['image'];
          
          
          String new_path="${first.dir!.path}/${widget.l['image']}";
           file=File(new_path);
          setState(() {

            
          });
      }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: (t)?Image.file(File(image!.path)):Image.file(file!),
              )
            ],
          ),
          ElevatedButton(onPressed: () async {

            String name=t1.text;
            String contact=t2.text;
            String email=t3.text;
            String password=t4.text;


              if(image!=null)
                {
                       File file1=File("${first.dir!.path}/${new_img}");
                       file1.delete();
                       new_img="${Random().nextInt(100)}.png";
                       File f=File("${first.dir!.path}/${new_img}");
                       f.writeAsBytes( await image!.readAsBytes());

                }

              String sql="update students set name='$name',"
                  "contact='$contact',email='$email',password='$password',"
                  "gender='$gen',city='$city',image='$new_img' where id='${widget.l['id']}'";
               first.database!.rawUpdate(sql);

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
