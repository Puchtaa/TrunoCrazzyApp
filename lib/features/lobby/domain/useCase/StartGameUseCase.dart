import 'package:trunocrazy/features/lobby/domain/entities/round.dart';
import 'package:trunocrazy/features/lobby/domain/repository/GameRepository.dart';
import 'package:trunocrazy/features/lobby/domain/repository/RoundRepository.dart';

class   StartGameUseCase{
    final RoundRepository roundRepository;
    final GameRepository gameRepository;

    StartGameUseCase({
        required this.roundRepository,
        required this.gameRepository,
    });

    Future<Round> call({required String lobbyId}) async {
        final round = await roundRepository.getCurrentRound(lobbyId: lobbyId);
        if(round.status == StatusRound.EM_ANDAMENTO){
            await gameRepository.startGame(lobbyId: lobbyId);
            return round;
        }else{
            throw Exception('Game has already started');
        }
    }
}