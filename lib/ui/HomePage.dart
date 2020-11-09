import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gifs_app/ui/gif_page.dart';
import 'package:http/http.dart' as http;
import 'package:outline_material_icons/outline_material_icons.dart';
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

const tredding =
    "https://api.giphy.com/v1/gifs/trending?api_key=HSRBWw4E6SkzJ6HYav3MMa0QNqKf7OAO&limit=20&rating=G";

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _pesquisa;
  int _offset = 0;

  Future<Map> _obterGifs() async {
    http.Response resposta;

    if (_pesquisa == null) {
      resposta = await http.get(tredding);
    } else {
      resposta = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=HSRBWw4E6SkzJ6HYav3MMa0QNqKf7OAO&q=$_pesquisa&limit=19&offset=$_offset&rating=G&lang=pt");
    }
    return json.decode(resposta.body);
  }

  @override
  void initState() {
    super.initState();

    _obterGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 16.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                if (text.isEmpty) {
                  setState(() {
                    _pesquisa = null;
                    _offset = 0;
                  });
                } else {
                  setState(() {
                    _pesquisa = text;
                    _offset = 0;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _obterGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 3.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_pesquisa == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_pesquisa == null || index < snapshot.data["data"].length) {
            return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot.data["data"][index]["images"]["fixed_height"]
                    ["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            GifPage(snapshot.data["data"][index])));
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]
                    ["fixed_height"]["url"]);
              },
            );
          } else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      OMIcons.add,
                      color: Colors.white,
                      size: 70,
                    ),
                    Text(
                      "Carregar mais...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    _offset += 19;
                  });
                },
              ),
            );
          }
        });
  }
}
