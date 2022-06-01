import 'package:flutter/material.dart';
import 'package:lista_compras/controller/registration_operation.dart';
import 'package:lista_compras/models/product_type.dart';
import 'package:lista_compras/view/entity_page.dart';
import 'package:lista_compras/view/entity_page_state.dart';
import 'package:lista_compras/view/message.dart';

class ProductTypePage extends StatefulWidget with EntityPage {
  ProductTypePage({required registrationOperation, required entity}) {
    this.registrationOperation = registrationOperation;
    this.entity = entity;
  }

  @override
  State<ProductTypePage> createState() => _ProductTypePageState();
}

class _ProductTypePageState extends State<ProductTypePage>
    with EntityPageState {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return createPage(context,
        widget.registrationOperation,
        'Tipo de Produto');
  }

  @override
  void initState() {
    super.initState();
    if (widget.registrationOperation == RegistrationOperation.update) {
      _nameController.text = (widget.entity as ProductType).name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  List<Widget> createFormContent(BuildContext context) {
    return [
      TextField(
        controller: _nameController,
        decoration: const InputDecoration(
          labelText: 'Nome',
        ),
      ),
    ];
  }

  @override
  bool isDataValid(BuildContext context) {
    ProductType productType = widget.entity as ProductType;
    if ((productType.name == null) || (productType.name == '')) {
      info(context, 'É necessário informar o nome.');
      return false;
    }
    return true;
  }

  @override
  void transferDataToEntity() {
    ProductType productType = widget.entity as ProductType;
    productType.name = _nameController.text;
  }
}
