import 'package:lista_compras/controller/registration_controller.dart';
import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/product_type.dart';

class ProductTypeRegistrationController extends RegistrationController {
  ProductTypeRegistrationController()
      : super(DatabaseDictionary.tableProductType, DatabaseDictionary.idProductType);

  @override
  Future<Entity> createEntity(Map<String, dynamic> entityMap) async {
    return ProductType.buildFromMap(entityMap);
  }
}
