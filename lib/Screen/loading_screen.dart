import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key? key,
    required AppBar appBar,
  })  : _appBar = appBar,
        super(key: key);

  final AppBar _appBar;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: _appBar,
      backgroundColor: Colors.grey[350],
      // ignore: unnecessary_null_comparison
      body: Center(
        child: Container(
          width: size.width * 0.4,
          height: size.width * 0.4,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                  Container(
                    height: 10,
                  ),
                  Text('Loading Data ...')
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
