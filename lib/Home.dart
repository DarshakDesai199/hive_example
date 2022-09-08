import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Box<String>? dataBox;
  final title = TextEditingController();
  final content = TextEditingController();
  @override
  void initState() {
    dataBox = Hive.box<String>("Note");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Text("Add Notes"),
                      TextFormField(
                        controller: title,
                        decoration: InputDecoration(hintText: "Title"),
                      ),
                      TextFormField(
                        controller: content,
                        decoration: InputDecoration(hintText: "Content"),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel")),
                    TextButton(
                        onPressed: () async {
                          await dataBox!.put("${Random().nextInt(100)}",
                              "${title.text}\n${content.text}");
                          Navigator.pop(context);
                          title.clear();
                          content.clear();
                        },
                        child: const Text("Add")),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add)),
      body: ValueListenableBuilder(
        valueListenable: dataBox!.listenable(),
        builder: (BuildContext context, Box<String> value, _) {
          return ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              var key = value.keys.toList()[index];
              var values = dataBox!.get(key);
              return ListTile(
                title: Text("$values"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Column(
                                  children: [
                                    Text("Add Notes"),
                                    TextFormField(
                                      controller: title,
                                      decoration:
                                          InputDecoration(hintText: "Title"),
                                    ),
                                    TextFormField(
                                      controller: content,
                                      decoration:
                                          InputDecoration(hintText: "Content"),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel")),
                                  TextButton(
                                    onPressed: () async {
                                      await dataBox!.put(key,
                                          "${title.text}\n${content.text}");
                                      Navigator.pop(context);
                                      title.clear();
                                      content.clear();
                                    },
                                    child: const Text("Update"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.edit)),
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Do you want to delete it?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("No")),
                                TextButton(
                                    onPressed: () {
                                      dataBox!.delete(key);
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Delete"))
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
