import 'package:clone_netflix/pages/downloads.dart';
import 'package:clone_netflix/pages/movie_catalog.dart';
import 'package:clone_netflix/pages/settings.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Widget> telas = [
    const MovieCatalog(),
    const Downloads(),
    const Settings(),
  ];

  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _indiceAtual,
          onTap: (indice) => setState(() => _indiceAtual = indice),
          items: const [
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
        body: telas[_indiceAtual],
      ),
    );
  }
}
