class Todo {
  String name;
  bool completed;
  String genero;
  String aniversario;

  Todo({this.name, this.completed = false, this.genero,this.aniversario});

  Todo.fromMap(Map map)
      : this.name = map['title'],
        this.completed = map['completed'],
        this.genero=map['genero'],
        this.aniversario=map['aniversario'];

  Map toMap() {
    return {
      'title': this.name,
      'completed': this.completed,
      'aniversario': this.aniversario,
      'genero':this.genero
    };
  }
}
