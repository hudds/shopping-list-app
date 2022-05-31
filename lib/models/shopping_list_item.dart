import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/product.dart';

class ShoppingListItem extends Entity {
  int itemNumber = 0;
  int idProduct = 0;
  Product _product = Product();
  double quantity = 0.0;
  bool selected = false;

  Product get product => _product;

  set product(Product product) {
    _product = product;
    idProduct = product.id;
  }

  ShoppingListItem(
      {int idShoppingList = 0, required this.itemNumber, required Product product, required this.quantity, required this.selected})
      :super(idShoppingList) {
    this.product = product;
  }

  ShoppingListItem.buildFromMap(Map<String, dynamic> entityMap)
      :super.buildFromMap(entityMap){
    id = entityMap[DatabaseDictionary.idShoppingList];
    itemNumber = entityMap[DatabaseDictionary.itemNumber];
    idProduct = entityMap[DatabaseDictionary.idProduct];
    quantity = entityMap[DatabaseDictionary.quantity];
    selected =
    entityMap[DatabaseDictionary.selected] == 'S' ? true : false;
  }

  @override
  Entity createEntity(Map<String, dynamic> entityMap) {
    return ShoppingListItem.buildFromMap(entityMap);
  }
  

  @override
  Map<String, dynamic> convertToMap() {
    return {
      DatabaseDictionary.idShoppingList: id,
      DatabaseDictionary.itemNumber: itemNumber,
      DatabaseDictionary.idProduct: idProduct,
      DatabaseDictionary.quantity: quantity,
      DatabaseDictionary.selected: selected ? 'S' : 'N',
    };
  }
}