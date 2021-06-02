import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ids_cadastro_pessoa/data/todo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cadastrar_pessoa_screen.dart';

class ListaScreen extends StatefulWidget {
  @override
  _ListaScreenState createState() => _ListaScreenState();
}

class _ListaScreenState extends State<ListaScreen> {
  List<Todo> list = new List<Todo>();
  SharedPreferences sharedPreferences;
  static const name = 0;
  static const genero = 2;
  static const aniver = 1;

  @override
  void initState() {
    loadSharedPreferencesAndData();

    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  void didChangeDependencies() async {
    await loadSharedPreferencesAndData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Lista de Pessoas',
            key: Key('main-app-title'),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => goToNewItemView(),
        ),
        body: list.isEmpty ? emptyList() : buildListView());
  }

  Widget emptyList() {
    return Center(child: Text('No items'));
  }

  Widget buildListView() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        return list.isEmpty ? emptyList() : buildItem(list[index], index);
      },
    );
  }

  Widget buildItem(Todo item, index) {
    return Container(color: Colors.white10, child: buildListTile(item, index));
  }

  int getIdade(String textNascimento) {
    List<String> campos = textNascimento.split('/');
    int dia = int.parse(campos[0]);
    int mes = int.parse(campos[1]);
    int ano = int.parse(campos[2]);
    DateTime nascimento = DateTime(ano, mes, dia);
    DateTime hoje = DateTime.now();
    int idade = hoje.year - nascimento.year;

    if (hoje.month < nascimento.month)
      idade--;
    else if (hoje.month == nascimento.month) {
      if (hoje.day < nascimento.day) idade--;
    }
    return idade;
  }

  Widget buildListTile(Todo item, int index) {
    int idade = getIdade(item.aniversario);

    return ListTile(
      onTap: () {
        return editarOuExcluir(item);
      }, //goToEditItemView(item),
      title: Text(
        item.name,
        key: Key('item-$index'),
        style: TextStyle(
            color: item.completed ? Colors.grey : Colors.black,
            decoration: item.completed ? TextDecoration.lineThrough : null),
      ),
      subtitle: Text(item.genero),
      trailing: Text('Idade $idade'),
    );
  }

  Future<Widget> editarOuExcluir(item) async {
    print('chamer');
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Você Deseja'),
          actions: [
            FlatButton(
              child: Text("Editar"),
              onPressed: () => goToEditItemView(item),
            ),
            FlatButton(
              child: Text("Apagar"),
              onPressed: () => apagarOuNao(item),
            )
          ],
        );
      },
    );
  }

  Future<Widget> apagarOuNao(item) async {
    Navigator.of(context).pop();
    return await showDialog(
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Deseja Apagar'),
          actions: [
            FlatButton(
              child: Text("sim"),
              onPressed: () => removeItem(item),
            ),
            FlatButton(
              child: Text("Não"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      },
    );
  }

  void goToNewItemView() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CadastrarPessoaWidget();
    })).then((title) {
      if (title != null) {
        setState(() {
          addItem(
              Todo(name: title[0], aniversario: title[1], genero: title[2]));
        });
      }
    });
  }

  void addItem(Todo item) {
    list.insert(0, item);
    saveData();
  }

  void goToEditItemView(item) {
    Navigator.of(context).pop();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CadastrarPessoaWidget(item: item);
    })).then((title) {
      if (title != null) {
        editItem(item, title);
      }
    });
  }

  void editItem(Todo item, List title) {
    item.name = title[name];
    item.genero = title[genero];
    item.aniversario = title[aniver];
    setState(() {
      saveData();
    });
  }

  void removeItem(Todo item) {
    Navigator.of(context).pop();

    list.remove(item);
    setState(() {
      saveData();
    });
  }

  void loadData() {
    List<String> listString = sharedPreferences.getStringList('list');
    if (listString != null) {
      list = listString.map((item) => Todo.fromMap(json.decode(item))).toList();
      setState(() {});
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('list', stringList);
    if (list.isEmpty) {}
  }
}
