import 'package:carousel_slider/carousel_slider.dart';
import 'package:clone_netflix/pages/downloads.dart';
import 'package:clone_netflix/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Movie.dart';
import '../widgets/movies_cards.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  List<Movie> movies = [];
  final List<Widget> telas = [
    Downloads(),
    Settings(),
  ];

  int _indiceAtual = 0;

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
        print(results);
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
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      primary: false,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (indice) => setState(() => _indiceAtual = indice),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tela 1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Tela 2',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tela 3',
          ),
        ],
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
      body: _indiceAtual != 0
          ? IndexedStack(index: _indiceAtual, children: telas)
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 1,
                    height: 600,
                    child: movies.isNotEmpty && movies.length >= 2
                        ? Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(movies[1].getPosterUrl()),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(
                                      top: 490, right: 100, left: 100),
                                  alignment: Alignment.center,
                                  child: ElevatedButton.icon(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.white),
                                    ),
                                    label: const Text(
                                      'Assistir',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    icon: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {},
                                  )),
                            ],
                          )
                        : const Center(
                            child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                  ),
                  //Lançamentos recentes
                  if (movies.isNotEmpty && movies.length >= 9)
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: const Text(
                              "Lançamentos recentes",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              viewportFraction: 1 / 3.2,
                              enableInfiniteScroll: false,
                              padEnds: false,
                              scrollPhysics: const BouncingScrollPhysics(),
                              enlargeCenterPage: false,
                            ),
                            items: [1, 2, 3, 4, 5].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return MoviesCards(
                                    title: movies[i].title,
                                    overview: movies[i].overview,
                                    posterPath: movies[i].getPosterUrl(),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  else
                    const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                  //Recomendados para você
                  if (movies.isNotEmpty && movies.length >= 9)
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: const Text(
                              "Recomendados para você",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              viewportFraction: 1 / 3.2,
                              enableInfiniteScroll: false,
                              padEnds: false,
                              scrollPhysics: const BouncingScrollPhysics(),
                              enlargeCenterPage: false,
                            ),
                            items: [6, 7, 8, 9, 10].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return MoviesCards(
                                    title: movies[i].title,
                                    overview: movies[i].overview,
                                    posterPath: movies[i].getPosterUrl(),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  else
                    const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                  //Melhores filmes
                  if (movies.isNotEmpty && movies.length >= 9)
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: const Text(
                              "Melhores filmes",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              viewportFraction: 1 / 3.2,
                              enableInfiniteScroll: false,
                              padEnds: false,
                              scrollPhysics: const BouncingScrollPhysics(),
                              enlargeCenterPage: false,
                            ),
                            items: [11, 12, 13, 14, 15].map((i) {
                              return Builder(
                                builder: (BuildContext context) {
                                  return MoviesCards(
                                    title: movies[i].title,
                                    overview: movies[i].overview,
                                    posterPath: movies[i].getPosterUrl(),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    )
                  else
                    const Center(
                        child: CircularProgressIndicator(color: Colors.white)),
                ],
              ),
            ),
    ));
  }
}
