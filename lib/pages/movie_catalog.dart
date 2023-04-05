import 'package:flutter/material.dart';
import '../models/Movie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/movies_cards.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MovieCatalog extends StatefulWidget {
  const MovieCatalog({Key? key}) : super(key: key);

  @override
  State<MovieCatalog> createState() => _MovieCatalogState();
}

class _MovieCatalogState extends State<MovieCatalog> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _isScrolledStart = false;
  List<Movie> movies = [];
  double previousScrollPosition = 0;

  _scrollListener() {
    double currentScrollPosition = _scrollController.position.pixels;
    if (_scrollController.offset > 0) {
      setState(() {
        _isScrolledStart = true;
      });
      if (currentScrollPosition > previousScrollPosition) {
        setState(() {
          _isScrolled = true;
        });
      } else {
        setState(() {
          _isScrolled = false;
        });
      }
      previousScrollPosition = currentScrollPosition;
    } else {
      setState(() {
        _isScrolledStart = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    fetchMovieData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      primary: false,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: _isScrolledStart
            ? const Color.fromRGBO(8, 6, 0, 100)
            : Colors.transparent,
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
        bottom: _isScrolled
            ? null
            : PreferredSize(
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
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              height: 600,
              child: movies.isNotEmpty && movies.length >= 2
                  ? Stack(
                      children: [
                        GestureDetector(
                          onTap: () => showDescription(
                              context,
                              movies[1].id,
                              movies[1].title,
                              movies[1].overview,
                              movies[1].getPosterUrl()),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(movies[1].getPosterUrl()),
                                fit: BoxFit.fill,
                              ),
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
                                    MaterialStateProperty.all(Colors.white),
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
                            return GestureDetector(
                              onTap: () => showDescription(
                                  context,
                                  movies[1].id,
                                  movies[i].title,
                                  movies[i].overview,
                                  movies[i].getPosterUrl()),
                              child: MoviesCards(
                                title: movies[i].title,
                                overview: movies[i].overview,
                                posterPath: movies[i].getPosterUrl(),
                              ),
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
    );
  }

  Future<void> showDescription(BuildContext context, int id, String title,
      String overview, String posterPath) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AnimatedContainer(
          duration: const Duration(
              milliseconds: 500), // definir a duração da animação
          curve: Curves.easeOutQuint, // definir a curva da animação
          transform: Matrix4.translationValues(
              0,
              MediaQuery.of(context).size.height * 0.6,
              0), // definir a posição inicial do diálogo abaixo da tela
          child: Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            width: MediaQuery.of(context).size.width,
            height: 500,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(54, 54, 54, 1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex:
                      2, // define o flex para 1, para que ocupe 20% da largura total
                  child: Container(
                    color: Colors.blue,
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(posterPath),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex:
                      4, // define o flex para 4, para que ocupe 80% da largura total
                  child: Container(
                    color: Colors.red,
                    child: Text("fa"),
                  ),
                ),
              ],
            ),
          ),
          onEnd: () {
            // código para ser executado após o término da animação
          },
        );
      },
    );
  }
}
