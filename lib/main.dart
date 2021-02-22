import 'package:flutter/material.dart';
import 'package:test_sqlite/memo_model.dart';

import 'dbHelper.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final myController = TextEditingController();

  List<MemoModel> listMemos;
  MemoDbProvider memoDb = MemoDbProvider();

  refreshStudentList() async {
    var memos = await memoDb.fetchMemos();
    setState(() {
      listMemos = memos;
    });
  }


  Future<int> deleteMymemo(int id) async {
    await memoDb.deleteMemo(id);
    refreshStudentList();
  }







@override
  void initState() {
    super.initState();

    refreshStudentList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<void> Insert(String title) async {
    WidgetsFlutterBinding.ensureInitialized();
    MemoDbProvider memoDb = MemoDbProvider();
    final memo = MemoModel(
      title: title,
    );
    print(title);
    await memoDb.addItem(memo);
    refreshStudentList();
    // var memos = await memoDb.fetchMemos();
    //
    // setState(() {
    //   listMemos = memos;
    // });

    // print(memos.runtimeType);
    //
    //
    //
    //
    //
    // for (var i = 0; i < listMemos.length; i++) {
    //   print(listMemos[i].title);
    // }
  }

  @override
  Widget build(BuildContext context) {
    print(listMemos.runtimeType);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Insert(myController.text);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
        child: Column(
          children: [
            TextFormField(
              controller: myController,
              decoration: InputDecoration(labelText: "Insert something"),
            ),
            Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: listMemos
                  .map(
                    (mem) => Row(
                      children: [
                        Text(
                          "${mem.id.toString()}) ${mem.title}",
                          style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
                        ),
                        IconButton(icon: Icon(Icons.delete), onPressed:  (){

                          deleteMymemo(mem.id);
                        }),
                        IconButton(icon: Icon(Icons.update), onPressed:  (){

                          // updateMemo();


                        }),

                      ],
                    ),
                  )
                  .toList(),
            ))
          ],
        ),
          ),
        ),
      ),
    );
  }



