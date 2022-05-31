import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lista_compras/data_base/database_access.dart';
import 'package:sqflite/sqflite.dart';

import '../models/entity.dart';

abstract class RegistrationController {
  final String table;
  final String idField;
  late List<Entity> entities;

  final StreamController<List<Entity>> _entityStreamController =
  StreamController<List<Entity>>();

  RegistrationController(this.table, this.idField);

  Future<void> beginStream() async {
    entities = await findAll();
    _entityStreamController.add(entities);

  }
  void closeStream(){
    _entityStreamController.close();
  }

  get entityStream{
    return _entityStreamController;
  }


  Future<int> insert(Entity entity) async {
    final database = await DatabaseAccess().database;
    int result = await database.insert(table, entity.convertToMap());
    return result;
  }

  Future<int> update(Entity entity) async {
    final database = await DatabaseAccess().database;
    int result = await database.update(table, entity.convertToMap(),
        where: '$idField = ? ', whereArgs: [entity.id]);
    return result;
  }

  Future<int> delete(int id) async {
    final database = await DatabaseAccess().database;
    int result =
        await database.delete(table, where: '$idField = ? ', whereArgs: [id]);
    return result;
  }

  Future<Entity> createEntity(Map<String, dynamic> mapaEntidade);

  Future<List<Entity>> createEntityList(result) async {
    List<Entity> entities = <Entity>[];
    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        Entity entity = await createEntity(result[i]);
        entities.add(entity);
      }
      return entities;
    }
    return [];
  }

  Future<Entity?> find(int id) async {
    final database = await DatabaseAccess().database;

    List<Map<String, dynamic>> entities =
        await database.query(table, where: '$idField = ? ', whereArgs: [id]);

    if (entities.isNotEmpty) {
      return await createEntity(entities.first);
    }
    return null;
  }

  Future<List<Entity>> findAll() async {
    Database? database = await DatabaseAccess().database;
    var result = await database.query(table);
    List<Entity> entities = await createEntityList(result);
    return entities;
  }
}
