import 'dart:io';

import 'package:path_provider/path_provider.dart';
import "package:sqflite/sqflite.dart";

import "database_dictionary.dart";

class DatabaseAccess {
  static late DatabaseAccess? _databaseAccess;
  static late Database? _database;

  DatabaseAccess._createInstance();

  factory DatabaseAccess() {
    _databaseAccess ??= DatabaseAccess._createInstance();
    return _databaseAccess!;
  }

  void close(){
    _database?.close();
  }

  Future<Database> get database async{
    if(_database ==  null){
      _database = await _openDatabaseConnection();
    }
    return _database!;
  }

  Future<Database> _openDatabaseConnection() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String databasePath = directory.path + DatabaseDictionary.databaseFile;
    Database database =
        await openDatabase(databasePath, version: 1, onCreate: _createTables);
    return database;
  }

  Future<void> _createTables(Database bancoDados, int versao) async {
    //Criação da tabela de tipos de produtos
    await bancoDados.execute("""
      CREATE TABLE ${DatabaseDictionary.tableProductType} (
      ${DatabaseDictionary.idProductType} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,  
      ${DatabaseDictionary.name} TEXT NOT NULL )""");
    //Criação da tabela de produtos
    await bancoDados.execute("""
         CREATE TABLE ${DatabaseDictionary.tableProduct} (  
            ${DatabaseDictionary.idProduct} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,  
            ${DatabaseDictionary.idProductType} INTEGER NOT NULL,  
            ${DatabaseDictionary.name} TEXT NOT NULL,  
            ${DatabaseDictionary.quantity} REAL NOT NULL,  
            ${DatabaseDictionary.unit} TEXT,  
            FOREIGN KEY (${DatabaseDictionary.idProductType}) REFERENCES ${DatabaseDictionary.tableProductType}(${DatabaseDictionary.idProductType})  ON UPDATE CASCADE  
          )
         """);
    //Criação da tabela de listas de compras
    await bancoDados.execute("""
        CREATE TABLE ${DatabaseDictionary.tableShoppingList} (  
          ${DatabaseDictionary.idShoppingList} INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,  
          ${DatabaseDictionary.name} TEXT NOT NULL 
        )
       """);
    //Criaçao da tabela de itens das listas
    await bancoDados.execute("""
        CREATE TABLE ${DatabaseDictionary.tableItemShoppingList} (  
          ${DatabaseDictionary.idShoppingList} INTEGER NOT NULL, 
          ${DatabaseDictionary.itemNumber} INTEGER NOT NULL, 
          ${DatabaseDictionary.idProduct} INTEGER NOT NULL, 
          ${DatabaseDictionary.quantity} REAL NOT NULL,  
          ${DatabaseDictionary.selected} TEXT NOT NULL,
          PRIMARY KEY (${DatabaseDictionary.idShoppingList},${DatabaseDictionary.itemNumber}),
          FOREIGN KEY (${DatabaseDictionary.idShoppingList}) REFERENCES ${DatabaseDictionary.tableShoppingList}(${DatabaseDictionary.idShoppingList})  
          ON UPDATE CASCADE   ON DELETE CASCADE,
          FOREIGN KEY (${DatabaseDictionary.idProduct})   REFERENCES ${DatabaseDictionary.tableProduct}(${DatabaseDictionary.idProduct}) ON UPDATE CASCADE
          ON DELETE CASCADE 
        )
    """);
  }
}
