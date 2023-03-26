import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models/Movie.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  List<Movie> movies = [];

  Future<void> fetchMovieData() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=905dc9bc830de51e779ffd8ea9ea309d&language=pt-BR&page=1'));

    if (response.statusCode == 200) {
      final decodedData = jsonDecode(response.body);
      final results = decodedData['results'];
      setState(() {
        movies = List.from(results)
            .map((movieData) => Movie.fromJson(movieData))
            .toList();
      });
    } else {
      throw Exception('Failed to load movie data');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchMovieData();
    _scrollController.addListener(() {
      if (_scrollController.offset > 0) {
        setState(() {
          _isScrolled = true;
        });
      } else {
        setState(() {
          _isScrolled = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Color.fromRGBO(100, 101, 100, 100),
      extendBodyBehindAppBar: true,
      primary: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: 600,
              child: Stack(
                children: [
                  movies.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(movies[1].getPosterUrl()),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                  Container(
                    padding:
                        const EdgeInsets.only(top: 450, right: 100, left: 100),
                    alignment: Alignment.center,
                    child: Text(
                      movies[1].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 2.0,
                            color: Colors.grey,
                            offset: Offset(1.5, 2.0),
                          ),
                        ],
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(100),
              child: const Text('as'),
            ),
            Container(
              padding: const EdgeInsets.all(100),
              child: const Text('as'),
            ),
            Container(
              padding: const EdgeInsets.all(100),
              child: const Text('as'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: _isScrolled ? 2.0 : 0.0,
        leading: IconButton(
          icon: Image.asset('assets/images/logo.png'),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.red,
              ),
              child: const Icon(Icons.person),
            ),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Séries',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Filmes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  child: const Text(
                    'Categorias',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
