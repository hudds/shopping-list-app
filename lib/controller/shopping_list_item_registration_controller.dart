import 'package:lista_compras/controller/product_registration_controller.dart';
import 'package:lista_compras/controller/registration_controller.dart';
import 'package:lista_compras/data_base/database_access.dart';
import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/product.dart';
import 'package:lista_compras/models/shopping_list_item.dart';

class ShoppingListItemRegistrationController extends RegistrationController {
  ProductRegistrationController productRegistrationController =
  ProductRegistrationController();

  ShoppingListItemRegistrationController()
      : super(
      DatabaseDictionary.tableItemShoppingList, DatabaseDictionary.idShoppingList);

  @override
  Future<Entity> createEntity(Map<String, dynamic> entityMap) async {
    ShoppingListItem shoppingListItem =
    ShoppingListItem.buildFromMap(entityMap);
    Product product = await
    productRegistrationController.find(
        shoppingListItem.idProduct) as Product;
    shoppingListItem.product = product;
    return shoppingListItem;
  }

  Future<List<Entity>> findByShoppingList(int idShoppingList) async {
    final database = await DatabaseAccess().database;

    List<Map> entityMap = await database.query(
        table, where: '${DatabaseDictionary.idShoppingList} = ? ',
        whereArgs: [idShoppingList]);
    List<Entity> entities = await
    createEntityList(entityMap);
    return entities;
  }

  Future<int> deleteFromShoppingList(int idShoppingList) async {
    final database = await DatabaseAccess().database;
    int result = await database.delete(
        table, where: '${DatabaseDictionary.idShoppingList} = ? ',
        whereArgs: [idShoppingList]);
    return result;
  }
}