import 'package:trunocrazy/features/lobby/domain/entities/game.dart';

abstract interface class GameRepository {
  Future<void> createGame({
    required String lobbyId,
  });

  Future<void> startGame({
    required String lobbyId,
  });

  Future<void> endGame({
    required String lobbyId,
  });

  Future<Game> getGame({
    required String lobbyId,
  });

}