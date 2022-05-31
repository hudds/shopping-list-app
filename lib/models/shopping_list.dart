import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/product.dart';
import 'package:lista_compras/models/shopping_list_item.dart';




class ShoppingList extends Entity {
  static const firstItemNumber = 1;
  int _itemNumber = firstItemNumber;
  String name = '';

  //Facilita a localização de um item
  final _items = <ShoppingListItem>[];

  ShoppingList({int idShopping = 0, this.name = ''}) : super(idShopping);

  ShoppingList.buildFromMap(Map<String, dynamic> entityMap)
      : super.buildFromMap(entityMap) {
    id = entityMap[DatabaseDictionary.idShoppingList];
    name = entityMap[DatabaseDictionary.name];
  }

  @override
  Entity createEntity(Map<String, dynamic> entityMap) {
    ShoppingList shoppingList = ShoppingList.buildFromMap(entityMap);
    for (var item in _items) {
      shoppingList.insertItem(item.copy as ShoppingListItem);
    }
    return shoppingList;
  }

  bool hasItems() {
    return _items.isNotEmpty;
  }

  List<ShoppingListItem> get items {
    return _items;
  }

  void clearItems() {
    _items.clear();
    _itemNumber = firstItemNumber;
  }

  void insertItem(ShoppingListItem item) {
    _items[item.itemNumber] = item;
    if (item.itemNumber > _itemNumber) {
      _itemNumber = item.itemNumber + 1;
    }
  }

  void insertProduct(Product product, double quantity) {
    ShoppingListItem item = ShoppingListItem(
        itemNumber: _itemNumber,
        product: product,
        quantity: quantity,
        selected: false);
    _items[_itemNumber] = item;
    _itemNumber++;
  }

  void removeItem(int itemNumber) {
    _items.removeAt(itemNumber);
  }

  List<ShoppingListItem> getItemsByType(int idProductType) {
    List<ShoppingListItem> entidades = [];
    for (var item in _items) {
      if ((idProductType == 0) ||
          (item.product.idProductType == idProductType)) {
        entidades.add(item);
      }
    }
    return entidades;
  }

  List<Product> getProductsByType(int idProductType) {
    List<Product> entities = [];
    for (var item in _items) {
      if ((idProductType == 0) ||
          (item.product.idProductType == idProductType)) {
        entities.add(item.product);
      }
    }
    return entities;
  }

  @override
  Map<String, dynamic> convertToMap() {
    Map<String, dynamic> values;
    values = {
      DatabaseDictionary.name: name,
    }; //Se id é maior que zero, é alteração!
    if (id > 0) {
      values.addAll({DatabaseDictionary.idShoppingList: id});
    }
    return values;
  }
}
