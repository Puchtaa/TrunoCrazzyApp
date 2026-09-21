import '../../domain/carta_truco.dart';
import '../services/baralho_truco_service.dart';

/// O repository é o intermediário entre a tela e a fonte dos dados.
class CatalogoRepository {
  const CatalogoRepository({this.service = const BaralhoTrucoService()});

  final BaralhoTrucoService service;

  List<CartaTruco> buscarCartas() => service.buscarCartas();
}
