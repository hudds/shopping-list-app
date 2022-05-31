import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';

class ProductType extends Entity {
  String name = '';

  ProductType({int id = 0, this.name = ''}) : super(id);

  ProductType.buildFromMap(Map<String, dynamic> entityMap)
      : super.buildFromMap(entityMap) {
    id = entityMap[DatabaseDictionary.idProductType];
    name = entityMap[DatabaseDictionary.name];
  }

  @override
  Entity createEntity(Map<String, dynamic> entityMap) {
    return ProductType.buildFromMap(entityMap);
  }

  @override
  Map<String, dynamic> convertToMap() {
    Map<String, dynamic> valores;
    valores = {
      DatabaseDictionary.name: name,
    };
    //Se identificador é maior que zero, trata-se de alteração!
    if (id > 0) {
      valores.addAll({DatabaseDictionary.idProductType: id});
    }
    return valores;
  }
}
