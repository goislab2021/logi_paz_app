import 'dart:core';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {

  // DbHelperをinstance化する
  static final DbHelper instance = DbHelper._createInstance();
  static Database? _database;

  DbHelper._createInstance();// インスタンスを作るための名前付きコンストラクタ

  // databaseをオープンしてインスタンス化する
  Future<Database> get database async {
    return _database ??= await _initDB();       // 初回だったら_initDB()=DBオープンする
  }

  // データベースをオープンする
  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'nogo.db');    //ｄｂパス取得

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,      // dbがなかった時の処理を指定する（DBは勝手に作られる）
    );
  }

  // データベースがなかった時の処理
  Future _onCreate(Database database, int version) async {
    //テーブルをcreateする
    await database.execute(
        'CREATE TABLE NO_GO_RECORDS('
            '_id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'DATE_YMD TEXT NOT NULL,'
            'TODO_TIME INTEGER NOT NULL,'
            'TODO TEXT NOT NULL,'
            'NO_GO_01 TEXT NOT NULL,'
            'NO_GO_02 TEXT,'
            'NO_GO_03 TEXT,'
            'NO_GO_04 TEXT,'
            'EVALUATION INTEGER,'
            'COMMENT TEXT,'
            'UPDATE_TIME TEXT,'
            'IMAGE_PATH TEXT'
            ');'
    );
    await database.execute(
        'CREATE TABLE EVALUATIONS('
            'EV_CODE INTEGER PRIMARY KEY,'
            'EVALUATION TEXT'
            ');'
    );
    await database.execute(
        'INSERT INTO EVALUATIONS('
            'EV_CODE,EVALUATION) '
            'VALUES'
            '(1,"◎"),'
            '(2,"〇"),'
            '(3,"△");'
    );
  }

//workingStateから
// データをinsertする
  Future<int?> insertMemo(String query, List<dynamic> args) async {
    int? recordid;
    final db = await database;
    await db.transaction((txn) async{
      recordid = await txn.rawInsert(query, args);
    });
    print("レコードIDは$recordid");
    return recordid;
  }

  //RatingInput、editRecord
  //評価をUPDATEする　
  updateMemo(String guery) async{
    final db = await database;
    await db.transaction((txn) async{
      await txn.rawUpdate(guery);
    });
  }

  //editRecord
  //レコードを削除する
  deleteMemo(String guery) async{
    final db = await database;
    await db.transaction((txn) async{
      await txn.rawDelete(guery);
    });
  }

  //recordList
  // レコード一覧を取得する
  Future<List<Map<String, dynamic>>>getMemo() async {
    final db = await database;
    return db.query('NO_GO_RECORDS', orderBy: "_id DESC");
  }


  //viewRegisteredContents
  //idで検索したレコード取得
  Future<Map<String, dynamic>> getRecord(int? id) async{
    final db = await database;
    List<Map<String,dynamic>> results = await db.query("NO_GO_RECORDS",
        where: "_id=?",
        whereArgs: [id]);
    Map<String, dynamic> map = results[0];
    return map;
  }

  //stampBook4
  //_idとimgpathのマップリスト取得 gurid作成用
  Future<List<Map<String, dynamic>>> getImgPathList()async{
    final db = await database;

    String _query
    = "SELECT _id,DATE_YMD,EVALUATION,IMAGE_PATH FROM NO_GO_RECORDS ORDER BY _id ASC;";

    List<Map<String,dynamic>> list = await db.rawQuery(_query);
    return list;
  }



}