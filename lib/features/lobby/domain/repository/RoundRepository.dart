import 'package:trunocrazy/features/lobby/domain/entities/round.dart';

abstract interface class RoundRepository{
    Future<Round> getCurrentRound({
        required String lobbyId,

    });

    
    Future<List<Round>> getRounds({
        required String lobbyId,
    });
    
}