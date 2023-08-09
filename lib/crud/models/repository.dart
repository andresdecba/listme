import 'package:listme/crud/models/lista.dart';

final listaUno = Lista(
  title: "lista UNO title",
  creationDate: DateTime.now(),
  items: [
    Item(content: 'lista UNO, contenido 1', isDone: true),
    Item(content: 'lista UNO, contenido 2', isDone: true),
    Item(content: 'lista UNO, contenido 3', isDone: true),
  ],
);

final listaDos = Lista(
  title: "lista DOS title",
  creationDate: DateTime.now(),
  items: [
    Item(content: 'lista DOS, contenido 1', isDone: true),
    Item(content: 'lista DOS, contenido 2', isDone: true),
    Item(content: 'lista DOS, contenido 3', isDone: true),
  ],
);

final listaTres = Lista(
  title: "lista TRES title",
  creationDate: DateTime.now(),
  items: [
    Item(content: 'lista TRES, contenido 1', isDone: true),
    Item(content: 'lista TRES, contenido 2', isDone: true),
    Item(content: 'lista TRES, contenido 3', isDone: true),
  ],
);

final listaCuatro = Lista(
  title: "lista CUATRO title",
  creationDate: DateTime.now(),
  items: [
    Item(content: 'lista CUATRO, contenido 1', isDone: true),
    Item(content: 'lista CUATRO, contenido 2', isDone: true),
    Item(content: 'lista CUATRO, contenido 3', isDone: true),
  ],
);

final newItem = Item(content: 'lista X, contenido xxx', isDone: true);
