import 'dart:convert';
import 'package:usuarios/modelos/usuario_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiPage extends StatefulWidget {
  const ApiPage({Key key}) : super(key: key);

  @override
  _ApiPageState createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  Future<List<Usuario>> _listaUsers;
  TextStyle estilosTexto = TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.deepOrange);
  Future<List<Usuario>> _obtenerUsers() async {
    List<Usuario> users = [];
    final respose =
        await http.get(Uri.parse('https://randomuser.me/api/?results=5'));

    if (respose.statusCode == 200) {
      String body = utf8.decode(respose.bodyBytes);

      final jsonData = jsonDecode(body);

      for (var item in jsonData['results']) {
        users.add(Usuario(
            name: item['name']['first'],
            last: item['name']['last'],
            picture: item['picture']['large'],
            ciudad: item['location']['city']));
      }
    } else {
      throw Exception('Fallo la llamada a la API');
    }

    return users;
  }

  @override
  void initState() {
    super.initState();

    _listaUsers = _obtenerUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Yessica Perez Reyes')),
      body: Center(
        child: FutureBuilder(
          future: _listaUsers,
          initialData: List<Usuario>.empty(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: _listadoUsuario(snapshot.data),
              );
            } else if (snapshot.error) {
              print(snapshot.error);
              print('Error al conectar a la API');
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _listadoUsuario(List<Usuario> data) {
    List<Widget> usuarioList = [];

    for (var user in data) {
      usuarioList.add(Card(
          child: Column(
        children: [
          Container(
            child: ClipOval(
              child: Align(
                  heightFactor: 0.7,
                  widthFactor: 0.7,
                  child: Image.network(user.picture)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nombre: ' + user.name + ' ' + user.last,
              style: estilosTexto,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Ciudad: ' + user.ciudad,
              style: estilosTexto,
            ),
          )
        ],
      )));
    }

    return usuarioList;
  }
}
