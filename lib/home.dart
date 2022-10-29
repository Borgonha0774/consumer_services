import 'package:consumer_services/post.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String _urlBase = 'https://jsonplaceholder.typicode.com';

  static const undefined = 'undefined';
  @undefined
  Future<List<Post>> _get() async {
    http.Response response = await http.get('$_urlBase/posts');
    var dadosJson = jsonDecode(response.body);

    List<Post> postagens = [];
    for (var post in dadosJson) {
      Post p = Post(post['userId'], post['id'], post['title'], post['body']);
      postagens.add(p);
    }

    return postagens;
  }

  _post() async {
    Post post = Post(120, 1, 'Titulo', 'Corpo Postagem');

    var corpo = jsonEncode(post.toJson());
    http.Response response = await http.post(
      '$_urlBase/posts',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: corpo,
    );

    print('StatusCode: ${response.statusCode}');
    print('Resposta: ${response.body}');
  }

  _put() async {
    var corpo = jsonEncode({
      "userId": 120,
      'id': null,
      'title': 'Titulo Novo',
      'body': 'Corpo da postagem Nova'
    });
    http.Response response = await http.put(
      '$_urlBase/posts/2',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: corpo,
    );

    print('StatusCode: ${response.statusCode}');
    print('Resposta: ${response.body}');
  }

  _patch() async {
    var corpo = jsonEncode({
      'title': 'Titulo Alterado',
    });
    http.Response response = await http.patch(
      '$_urlBase/posts/2',
      headers: {'Content-type': 'application/json; charset=UTF-8'},
      body: corpo,
    );

    print('StatusCode: ${response.statusCode}');
    print('Resposta: ${response.body}');
  }

  _delete() async {
    http.Response response = await http.delete(
      '$_urlBase/posts/2',
    );

    print('StatusCode: ${response.statusCode}');
    print('Resposta: ${response.body}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Consumer Services'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  ElevatedButton(
                    onPressed: _post,
                    child: const Text('post'),
                  ),
                  ElevatedButton(
                    onPressed: _put,
                    child: const Text('put'),
                  ),
                  ElevatedButton(
                    onPressed: _patch,
                    child: const Text('patch'),
                  ),
                  ElevatedButton(
                    onPressed: _delete,
                    child: const Text('delete'),
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<Post>>(
                  future: _get(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.none:
                        break;
                      case ConnectionState.waiting:
                        const Center(
                          child: CircularProgressIndicator(),
                        );

                        break;
                      case ConnectionState.active:
                        break;
                      case ConnectionState.done:
                        if (snapshot.hasError) {
                          print('Erro ao carregar as postagens');
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              List<Post>? lista = snapshot.data;
                              Post post = lista![index];

                              return ListTile(
                                title: Text(post.title),
                                subtitle: Text(post.id.toString()),
                              );
                            },
                          );
                        }
                        break;
                      default:
                        return throw '';
                    }
                    return const Center(
                      child: Text('err'),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
