import 'package:flutter/material.dart';
import 'package:lista_compras/controller/registration_controller.dart';
import 'package:lista_compras/controller/registration_operation.dart';
import 'package:lista_compras/models/entity.dart';
import 'package:lista_compras/view/message.dart';

mixin RegistrationPage {
  late RegistrationController registrationController;
  List<Entity> entities = [];

  List<Widget> createItemContent(Entity entity);

  Widget createEntityPage(RegistrationOperation operation, Entity entity);

  void showSnackBar(BuildContext context, String message) {
    final SnackBar stackBar = SnackBar(
      content: Text(message),
    );
    ScaffoldMessenger.of(context).showSnackBar(stackBar);
  }

  void openEntityPage(BuildContext context, RegistrationOperation operation,
      Entity entity) async {
    bool confirmed =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return createEntityPage(operation, entity);
    }));
    if (confirmed) {
      int result;
      if (operation == RegistrationOperation.insert) {
        result = await registrationController.insert(entity);
      } else {
        result = await registrationController.update(entity);
      }
      if (result > 0) {
        registrationController.beginStream();
        showSnackBar(
            context,
            operation == RegistrationOperation.insert
                ? 'Inclusão realizada com sucesso.'
                : 'Alteração realizada com sucesso.');
      } else {
        showSnackBar(context, 'Operação não foi realizada.');
      }
    }
  }

  Widget createListItem(context, index) {
    return Dismissible(
      key: Key(entities[index].id.toString()),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerLeft,
        child: const Align(
          alignment: Alignment(-0.9, 0),
          child: Icon(Icons.delete, color: Colors.white),
        ),
      ),
      confirmDismiss: (direction) async {
        bool? confirmed = await confirm(context, 'Deseja realmente excluir');
        return confirmed;
      },
      onDismissed: (direction) async {
        int resultado = await registrationController.delete(entities[index].id);
        if (resultado > 0) {
          registrationController.beginStream();
          showSnackBar(context, 'Exclusão realizada com sucesso');
        }
      },
      child: GestureDetector(
        child: Card(
          child: Container(
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: createItemContent(entities[index])),
          ),
        ),
        onTap: () {
          openEntityPage(
              context, RegistrationOperation.update, entities[index].copy);
        },
      ),
    );
  }

  Widget createList() {
    if (registrationController == null) {
      return Container(
        child: Text(
          'Controle não instanciado',
          style: TextStyle(
            fontSize: 30,
          ),
        ),
      );
    }
    return StreamBuilder<List<Entity>>(
        stream: registrationController.entityStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            entities = snapshot.data!;
            return ListView.builder(
                padding: EdgeInsets.all(5.0),
                itemCount: entities.length,
                itemBuilder: (context, index) {
                  return createListItem(context, index);
                });
          } else {
            return Container(
              alignment: Alignment.center,
              child: Text(
                'Inclua os itens!',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            );
          }
        });
  }

  Entity createEntity();

  Widget? createDrawer() {
    return null;
  }

  Widget createPage(BuildContext context, String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
        ),
        centerTitle: true,
      ),
      drawer: createDrawer(),
      body: createList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          openEntityPage(context, RegistrationOperation.insert, createEntity());
        },
      ),
    );
  }
}
