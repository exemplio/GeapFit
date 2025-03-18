// ignore_for_file: must_be_immutable

import "package:flutter/material.dart";

class ShowErrorMessage extends StatelessWidget {
  String errorMessage;
  bool error;
  ShowErrorMessage({
    Key? key,
    this.errorMessage = "NO HAY INFORMACIÓN DISPONIBLE",
    this.error = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Center(
        //     child: asset),
        const SizedBox(height: 10),
        Text(errorMessage, textAlign: TextAlign.center),
      ],
    );
  }
}
