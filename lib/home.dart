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
  Future<List<Post>> _recuperarPostagens() async {
    http.Response response = await http.get('$_urlBase/posts');
    var dadosJson = jsonDecode(response.body);

    List<Post> postagens = [];
    for (var post in dadosJson) {
      print("post: " + post["title"]);
      Post p = Post(post['userId'], post['id'], post['title'], post['body']);
      postagens.add(p);
    }

    return postagens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consumer Services'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _recuperarPostagens(),
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
                print('Lista carregada');
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
    );
  }
}
