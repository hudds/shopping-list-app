import 'package:lista_compras/controller/registration_controller.dart';
import 'package:lista_compras/controller/shopping_list_item_registration_controller.dart';
import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/shopping_list.dart';
import 'package:lista_compras/models/shopping_list_item.dart';

class ControleCadastroListaCompra extends RegistrationController {
  ShoppingListItemRegistrationController
      shoppingListItemRegistrationController =
      ShoppingListItemRegistrationController();

  ControleCadastroListaCompra()
      : super(DatabaseDictionary.tableShoppingList,
            DatabaseDictionary.idShoppingList);

  Future<Entity> createEntity(Map<String, dynamic> entityMap) async {
    ShoppingList shoppingList = ShoppingList.buildFromMap(entityMap);
    List<Entity> items = await shoppingListItemRegistrationController
        .findByShoppingList(shoppingList.id);
    for (var element in items) {
      shoppingList.insertItem(element as ShoppingListItem);
    }
    return shoppingList;
  }

  Future<int> processItems(ShoppingList shoppingList) async {
    int result = 0;
    shoppingListItemRegistrationController
        .deleteFromShoppingList(shoppingList.id);
    for (int i = 0; i < shoppingList.items.length; i++) {
      //Corrige o idCompra da lista de tens
      shoppingList.items[i].id = shoppingList.id;
      result = await shoppingListItemRegistrationController
          .insert(shoppingList.items[i]);
    }
    return result;
  }

  @override
  Future<int> insert(Entity entity) async {
    ShoppingList shoppingList = entity as ShoppingList;
    int result;
    result = await super.insert(shoppingList);
    if (result > 0) {
      shoppingList.id = result;
      result = await processItems(shoppingList);
    }
    return result;
  }

  @override
  Future<int> update(Entity entity) async {
    ShoppingList shoppingList = entity as ShoppingList;
    int result;
    result = await super.update(shoppingList);

    if (result > 0) {
      result = await processItems(shoppingList);
    }
    return result;
  }

  @override
  Future<int> delete(int id) async {
    int result;
    result = await super.delete(id);
    if (result > 0) {
      result = await shoppingListItemRegistrationController
          .deleteFromShoppingList(id);
    }
    return result;
  }
}
