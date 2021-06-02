import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:ids_cadastro_pessoa/data/todo.dart';

class CadastrarPessoaWidget extends StatefulWidget {
  final Todo item;

  CadastrarPessoaWidget({this.item});

  @override
  _CadastrarPessoaWidgetViewState createState() =>
      _CadastrarPessoaWidgetViewState();
}

class _CadastrarPessoaWidgetViewState extends State<CadastrarPessoaWidget> {
  TextEditingController titleController;
  String name = '';
  String dataNascimento;
  List genero = ['masculino', "femino"];
  var _selectedValue;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(
        text: widget.item != null ? widget.item.name : null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.item != null ? 'Editar ${widget.item.name}' : 'Novo Cadastro',
          key: Key('new-item-title'),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(right: 35, left: 35),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  maxLength: 70,
                  onChanged: (nome_pessoa) {
                    name = nome_pessoa;
                  },
                  autofocus: true,
                  validator: (nome_pessoa) {
                    if (nome_pessoa.isEmpty) {
                      return 'Digite seu nome';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: 'Nome Completo'),
                ),
                SizedBox(
                  height: 14.0,
                ),
                Container(
                  child: DropdownButtonFormField(
                    hint: Text("Qual seu Sexo"),
                    value: _selectedValue,
                    validator: (value) =>
                        value == null ? 'Qual seu genero' : null,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                    items: genero.map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  decoration: InputDecoration(
                    prefixText: ' ',
                    hintText: 'Data de Nascimento',
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                    border: OutlineInputBorder(),
                  ),
                  onTap: () => _selectData(context),
                  validator: (value) {
                    if (value.isEmpty) return "Qual sua data de Nascimento";
                    return null;
                  },
                  controller: _dateController,
                  onSaved: (val) {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Salvar',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          submit();
                        }
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                            color:
                                Theme.of(context).primaryTextTheme.title.color),
                      ),
                      elevation: 3.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10.0),
                              topRight: Radius.circular(10.0))),
                      onPressed: () {
                        return descatarOuNao();
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Widget> descatarOuNao() async {
    print('chamer');
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Deseja realmente fechar a tela?'),
            actions: [
              FlatButton(
                child: Text("sim"),
                onPressed: () =>
                    {Navigator.of(context).pop(), Navigator.of(context).pop()},
              ),
              FlatButton(
                child: Text("não"),
                onPressed: () => {Navigator.of(context).pop()},
              )
            ],
          );
        });
  }

  _selectData(BuildContext context) {
    dataNascimento = null;
    showDatePicker(
            context: context,
            initialDate:
                dataNascimento == null ? DateTime.now() : dataNascimento,
            firstDate: DateTime(1900),
            lastDate: DateTime(2022))
        .then((date) {
      setState(() {
        dataNascimento = DateFormat("dd/MM/yyyy").format(date);
        _dateController.text = dataNascimento;
      });
    });
  }

  Widget getDataNascimento() {
    return RaisedButton(
      child: Text('Data Nascimento'),
      onPressed: () {
        showDatePicker(
                context: context,
                initialDate:
                    dataNascimento == null ? DateTime.now() : dataNascimento,
                firstDate: DateTime(2001),
                lastDate: DateTime.now())
            .then((date) {
          setState(() {
            dataNascimento = DateFormat("dd/MM/yyyy").format(date);
          });
        });
      },
    );
  }

  void submit() {
    Navigator.of(context).pop(
      [name, dataNascimento.toString(), _selectedValue],
    );
  }

  Widget buildTitle({
    @required String title,
    @required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}
