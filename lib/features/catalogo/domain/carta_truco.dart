/// Os quatro naipes usados no baralho do jogo.
enum Naipe {
  paus('Paus', '♣'),
  copas('Copas', '♥'),
  espadas('Espadas', '♠'),
  ouros('Ouros', '♦');

  const Naipe(this.nome, this.simbolo);

  final String nome;
  final String simbolo;
}

/// No Truco, o baralho possui 10 valores por naipe: 40 cartas ao todo.
enum ValorCarta {
  quatro('4'),
  cinco('5'),
  seis('6'),
  sete('7'),
  dama('Q'),
  valete('J'),
  rei('K'),
  as('A'),
  dois('2'),
  tres('3');

  const ValorCarta(this.simbolo);

  final String simbolo;
}

/// Uma carta do baralho de Truco.
class CartaTruco {
  const CartaTruco({required this.valor, required this.naipe});

  final ValorCarta valor;
  final Naipe naipe;

  String get nome => '${valor.simbolo} de ${naipe.nome}';
}
