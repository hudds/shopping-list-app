import 'package:flutter/material.dart';
import 'package:lista_compras/controller/registration_operation.dart';

mixin EntityPageState {
  List<Widget> createFormContent(BuildContext context);

  void transferDataToEntity();

  bool isDataValid(BuildContext context);

  String buildTitle(RegistrationOperation operation, String title) {
    switch (operation) {
      case RegistrationOperation.insert:
        return 'Inclusão de ' + title;
      case RegistrationOperation.update:
        return 'Edição de ' + title;
      case RegistrationOperation.find:
        return 'Seleção de ' + title;
    }
  }

  Widget createForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: createFormContent(context) +
            [
              const SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextButton(
                    child: const Text('Salvar'),
                    onPressed: () {
                      transferDataToEntity();
                      if (isDataValid(context)) {
                        Navigator.pop(context, true);
                      }
                    },
                  ),
                  const SizedBox(
                    width: 50.0,
                  ),
                  TextButton(
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                  )
                ],
              )
            ],
      ),
    );
  }

  Widget createPage(BuildContext context,
      RegistrationOperation registrationOperation, String title) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          buildTitle(registrationOperation, title),
        ),
        centerTitle: true,
      ),
      body: createForm(context),
    );
  }
}
