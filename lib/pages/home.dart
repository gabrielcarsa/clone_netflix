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
          unselectedItemColor: const Color.fromRGBO(170, 170, 170, 100),
          selectedItemColor: Colors.white,
          backgroundColor: Colors.black,
          currentIndex: _indiceAtual,
          onTap: (indice) => setState(() => _indiceAtual = indice),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download_for_offline_outlined),
              activeIcon: Icon(Icons.download_for_offline),
              label: 'Downloads',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
        body: telas[_indiceAtual],
      ),
    );
  }
}
