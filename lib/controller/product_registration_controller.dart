import 'package:lista_compras/controller/product_type_registration_controller.dart';
import 'package:lista_compras/controller/registration_controller.dart';
import 'package:lista_compras/data_base/database_access.dart';
import 'package:lista_compras/data_base/database_dictionary.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/product.dart';
import 'package:lista_compras/models/product_type.dart';

class ProductRegistrationController extends RegistrationController {
  ProductTypeRegistrationController productTypeRegistrationController =
      ProductTypeRegistrationController();

  ProductRegistrationController()
      : super(DatabaseDictionary.tableProduct, DatabaseDictionary.idProduct);

  @override
  Future<Entity> createEntity(Map<String, dynamic> entityMap) async {
    Product product = Product.buildFromMap(entityMap);
    ProductType productType = await productTypeRegistrationController
        .find(product.idProductType) as ProductType;
    product.productType = productType;
    return product;
  }

  Future<List<Entity>> findByType(int idProductType) async {
    final database = await DatabaseAccess().database;

    List<Map> entityMap;
    if (idProductType > 0) {
      entityMap = await database.query(table,
          where: '${DatabaseDictionary.idProductType} = ? ',
          whereArgs: [idProductType]);
    } else {
      entityMap = await database.query(table);
    }
    List<Entity> entidades = await createEntityList(entityMap);
    return entidades;
  }
}
