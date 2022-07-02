import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const AppListaPalabras());
}

class AppListaPalabras extends StatelessWidget {
  const AppListaPalabras({Key? key}) : super(key: key); //constructor

  @override
  Widget build(BuildContext context) {
    //necesario para mostrar la pantalla de la app
    final palabra = WordPair.random();
    return MaterialApp(
      title: 'Generador Lista de Palabras',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Generador Lista de Palabras'),
        ),
        body: Center(
          //child: Text('Hola Mundo'),
          child: Text(palabra.asPascalCase),
        ),
      ),
    );
  }
}

//creamos un stateful widget
class ParPalabras extends StatefulWidget {
  const ParPalabras({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ParPalabrasState();
}

//manejo del estado del widget ParPalabras
class _ParPalabrasState extends State<ParPalabras> {
  //_itemSet es una coleccion Set para guardar
  //los pares de palabras, que el usuario va a
  //marcar como favoritos. Set no permite duplicados
  final _itemSet = <WordPair>{};
  final _filasPalabra = <WordPair>[];
  final _letraGrande = const TextStyle(fontSize: 18);
  @override
  Widget build(BuildContext context) {
    //final palabra = WordPair.random();
    //return Text(palabra.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador Lista de Palabras'),
        actions: [
          IconButton(
            onPressed: _agregarFavorito,
            icon: const Icon(Icons.list),
            tooltip: 'Favoritos guardados',
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          //si el item es impar, dibuja una linea de division
          if (i.isOdd) return const Divider();
          //verifica si estoy al final de la lista
          //genera 10 filas adicionales
          final index = i ~/ 2;
          //i ~/ 2 lo que hace es dividir i entre 2 y
          //retorna un int como resultado, omite totalmente la parte decimal
          if (index >= _filasPalabra.length) {
            _filasPalabra.addAll(generateWordPairs().take(10));
          }
          //la variable parExiste verifica que un par de
          //palabras no hayan sido agregados aun al Set _itemSet
          //el metodo contains() busca segun el criterio y
          //devuelve true o false
          final parExiste = _itemSet.contains(_filasPalabra[index]);

          return ListTile(
            title: Text(
              _filasPalabra[index].asPascalCase,
              style: _letraGrande,
            ),
            trailing: Icon(
              parExiste ? Icons.favorite : Icons.favorite_border,
              color: parExiste ? Colors.red : null,
              semanticLabel:
                  parExiste ? 'Remover de favoritos' : "Agregar a favoritos",
            ),
            onTap: () {
              setState(() {
                if (parExiste) {
                  _itemSet.remove(_filasPalabra[index]);
                } else {
                  _itemSet.add(_filasPalabra[index]);
                }
              });
            },
          );
        },
      ),
    );
  }

  void _agregarFavorito() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      final filaFavorito = _itemSet.map((par) {
        return ListTile(
          title: Text(
            par.asPascalCase,
            style: _letraGrande,
          ),
        );
      });
      final divisor = filaFavorito.isNotEmpty
          ? ListTile.divideTiles(context: context, tiles: filaFavorito).toList()
          : <Widget>[];

      return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de favoritos guardados'),
        ),
        body: ListView(
          children: divisor,
        ),
      );
    }));
  }
}
