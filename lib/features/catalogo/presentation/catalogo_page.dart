import 'package:flutter/material.dart';

import '../data/repositories/catalogo_repository.dart';
import '../domain/carta_truco.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key, this.repository = const CatalogoRepository()});

  final CatalogoRepository repository;

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
  Naipe? naipeSelecionado;

  @override
  Widget build(BuildContext context) {
    final cartasDoBaralho = widget.repository.buscarCartas();
    final cartas = naipeSelecionado == null
        ? cartasDoBaralho
        : cartasDoBaralho
            .where((carta) => carta.naipe == naipeSelecionado)
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Baralho de Truco')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Todos'),
                  selected: naipeSelecionado == null,
                  onSelected: (_) => setState(() => naipeSelecionado = null),
                ),
                ...Naipe.values.map(
                  (naipe) => ChoiceChip(
                    label: Text('${naipe.simbolo} ${naipe.nome}'),
                    selected: naipeSelecionado == naipe,
                    onSelected: (_) => setState(() => naipeSelecionado = naipe),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: cartas.length,
              itemBuilder: (context, index) => _CartaWidget(carta: cartas[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartaWidget extends StatelessWidget {
  const _CartaWidget({required this.carta});

  final CartaTruco carta;

  @override
  Widget build(BuildContext context) {
    final vermelha = carta.naipe == Naipe.copas || carta.naipe == Naipe.ouros;
    final cor = vermelha ? Colors.red : Colors.black;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(carta.valor.simbolo, style: TextStyle(fontSize: 24, color: cor)),
            const Spacer(),
            Center(child: Text(carta.naipe.simbolo, style: TextStyle(fontSize: 34, color: cor))),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(carta.valor.simbolo, style: TextStyle(fontSize: 18, color: cor)),
            ),
          ],
        ),
      ),
    );
  }
}
