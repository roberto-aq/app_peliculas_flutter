import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  Stream<String> getLoadingMessages() {
    final messages = <String>[
      'Cargando películas...',
      'Comprando palomitas...',
      'Buscando asientos...',
      'Encendiendo proyector...',
      'Ajustando volumen...',
    ];

    return Stream.periodic(const Duration(seconds: 1), (i) {
      return messages[i];
    }).take(messages.length);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          const SizedBox(height: 20),
          StreamBuilder(
            stream: getLoadingMessages(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!);
              }
              return const Text('Cargando...');
            },
          )
        ],
      ),
    );
  }
}
