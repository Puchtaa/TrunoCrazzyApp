import '../../domain/carta_truco.dart';
import '../baralho_truco.dart';

/// Camada que busca os dados das cartas.
/// Por enquanto os dados são locais; depois pode buscar uma API aqui.
class BaralhoTrucoService {
  const BaralhoTrucoService();

  List<CartaTruco> buscarCartas() => baralhoTruco;
}
