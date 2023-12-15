// view 

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:offline_demo/edit_data.dart';
import 'package:offline_demo/main.dart';

class view_data extends StatefulWidget {
  const view_data({super.key});

  @override
  State<view_data> createState() => _view_dataState();
}

class _view_dataState extends State<view_data> {

  List<Map>l=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    get();
  }
  get()
  {

          String sql="select * from students";
           first.database!.rawQuery(sql).then((value) {
                l=value;
                print(l);
                setState(() {

                });
           });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),

      body: ListView.builder(
        itemCount: l.length,
        itemBuilder: (context, index) {

            String img_path="${first.dir!.path}/${l[index]['image']}";
            File f=File(img_path);
          
         return Card(child: ListTile(
           title: Text("${l[index]['name']}"),
           subtitle: Text("${l[index]['contact']}"),
           leading: CircleAvatar(
             backgroundImage: FileImage(f),
           ),
           trailing: Wrap(
             children: [
               IconButton(onPressed: () {

                   String sql="delete from students where id='${l[index]['id']}'";
                   first.database!.rawDelete(sql);
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return view_data();
                   },));
                   setState(() {

                   });

               }, icon: Icon(Icons.delete)),
               IconButton(onPressed: () {
                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                   return edit_data(l[index]);
                 },));
               }, icon: Icon(Icons.edit))
             ],
           ),
         ),);
      },),

    );
  }
}
