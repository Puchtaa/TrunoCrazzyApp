class Round {
  final int roundNumber;
  final List<String> players;
  final StatusRound status;

  const Round({required this.roundNumber, 
    required this.players, 
    required this.status});
}
enum StatusRound {
    EM_ANDAMENTO,
    FINALIZADO
}