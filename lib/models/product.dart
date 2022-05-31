import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/product_type.dart';

const List<String> productUnits =
['','un','kg','g', 'mg', 'l', 'ml'];

class Product extends Entity {
  ProductType _productType = ProductType();
  String name = '';
  double quantity = 0.0;
  String unit = '';
  int idProductType = 0;

  Product({
    int idProduct = 0,
    this.name = '',
    this.quantity = 0.0,
  }) : super(idProduct);

  Product.buildFromMap(Map<String, dynamic> entityMap)
      : super.buildFromMap(entityMap) {
    id = entityMap[DatabaseDictionary.idProduct];
    name = entityMap[DatabaseDictionary.name];
    quantity = entityMap[DatabaseDictionary.quantity];
    idProductType = entityMap[DatabaseDictionary.idProductType];
    unit = entityMap[DatabaseDictionary.unit];
  }

  @override
  Entity createEntity(Map<String, dynamic> entityMap) {
    return Product.buildFromMap(entityMap);
  }

  ProductType get productType => _productType;

  set productType(ProductType productType) {
    _productType = productType;
    idProductType = productType.id;
  }

  @override
  Map<String, dynamic> convertToMap() {
    Map<String, dynamic> values;
    values = {
      DatabaseDictionary.idProductType: idProductType,
      DatabaseDictionary.name: name,
      DatabaseDictionary.quantity: quantity,
      DatabaseDictionary.unit: unit,
    }; //Se id é maior que zero, é uma alteração!
    if (id > 0) {
      values.addAll({DatabaseDictionary.idProduct: id});
    }
    return values;
  }
}
