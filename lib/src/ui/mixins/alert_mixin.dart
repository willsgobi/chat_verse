import 'package:flutter/material.dart';

mixin AlertDialogMixin {
  Future showAlertDialog(
      {required BuildContext context,
      required String title,
      required String message,
      required Function onAccepted}) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(
              message,
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
                child: const Text("Sim"),
                onPressed: () {
                  Navigator.of(context).pop();
                  onAccepted();
                },
              ),
            ],
          );
        });
  }
}
