import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  final loadingCaption;

  LoadingOverlay(this.loadingCaption);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: double.infinity,
        color: Color.fromRGBO(0, 0, 0, .5),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          CircularProgressIndicator(),
          SizedBox(
            width: 15,
          ),
          Text(
            loadingCaption,
            style: TextStyle(color: Colors.white),
          ),
        ]),
      ),
    );
  }
}
