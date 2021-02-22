import 'package:sqflite/sqflite.dart'; //sqflite package
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:path/path.dart'; //used to join paths
import './memo_model.dart'; //import model class
import 'dart:io';
import 'dart:async';

class MemoDbProvider{

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"testSQL.db"); //create path to database

    return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE Test(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT)"""
          );

        });
  }

  Future<int> addItem(MemoModel item) async{ //returns number of items inserted as an integer

    final db = await init(); //open database

    return db.insert("Test", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<MemoModel>> fetchMemos() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Test"); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) { //create a list of memos
      return MemoModel(
        id: maps[i]['id'],
        title: maps[i]['title'],

      );
    });
  }
  
  Future<int> deleteMemo(int id) async {

    final db = await init();
    return await db.delete("Test", where: 'id = ?' , whereArgs: [id]);

  }

}