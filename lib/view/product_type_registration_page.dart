import 'package:flutter/material.dart';
import 'package:lista_compras/controller/product_type_registration_controller.dart';
import 'package:lista_compras/controller/registration_operation.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/models/product_type.dart';
import 'package:lista_compras/view/entity_page.dart';
import 'package:lista_compras/view/entity_page_state.dart';
import 'package:lista_compras/view/product_type_page.dart';
import 'package:lista_compras/view/registration_page.dart';

class ProductTypeRegistrationPage extends StatefulWidget {
  const ProductTypeRegistrationPage({Key? key}) : super(key: key);

  @override
  State<ProductTypeRegistrationPage> createState() =>
      _ProductTypeRegistrationPageState();
}

class _ProductTypeRegistrationPageState
    extends State<ProductTypeRegistrationPage> with RegistrationPage {
  @override
  Widget build(BuildContext context) {
    return createPage(context, 'Tipos de Produtos');
  }

  @override
  void initState() {
    super.initState();
    registrationController = ProductTypeRegistrationController();
    registrationController.beginStream();
  }

  @override
  void dispose() {
    registrationController.closeStream();
    super.dispose();
  }

  @override
  Entity createEntity() {
    return ProductType(name: '');
  }

  @override
  Widget createEntityPage(RegistrationOperation operation, Entity entity) {
    return ProductTypePage(registrationOperation: operation, entity: entity);
  }

  @override
  List<Widget> createItemContent(Entity entity) {
    return [
      const SizedBox(
        height: 35,
      ),
      Text(
        (entity as ProductType).name,
      ),
      const SizedBox(
        height: 35,
      ),
    ];
  }
}
