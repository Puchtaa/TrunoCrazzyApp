import 'package:flutter/material.dart';

import '../../../../core/ui/formatters/card_labels.dart';
import '../../domain/entities/game_player.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/enums/game_direction.dart';
import '../../domain/enums/game_phase.dart';
import '../../domain/enums/round_status.dart';
import '../controllers/game_controller.dart';
import '../widgets/hand_view.dart';
import '../widgets/players_bar.dart';
import '../widgets/puzzle_dialog.dart';
import '../widgets/table_plays.dart';

GamePlayer? findMe(GameState s, String nickname) {
  for (final player in s.players) {
    if (player.nickname == nickname) return player;
  }
  return null;
}

bool isMyTurn(GameState s, GamePlayer? me) =>
    me != null && s.currentPlayerId == me.id;

class GamePage extends StatefulWidget {
  const GamePage({
    super.key,
    required this.controller,
    required this.myNickname,
    required this.onExit,
  });

  final GameController controller;
  final String myNickname;
  final VoidCallback onExit;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _puzzleOpen = false;

  @override
  void initState() {
    super.initState();
    widget.controller.startPolling();
    widget.controller.addListener(_maybeShowPuzzle);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_maybeShowPuzzle);
    widget.controller.dispose();
    super.dispose();
  }

  void _maybeShowPuzzle() {
    final state = widget.controller.state;
    final me = findMe(state, widget.myNickname);
    if (state.pendingPuzzle != null &&
        state.roundStatus == RoundStatus.aguardandoPuzzle &&
        state.currentPlayerId == me?.id &&
        !_puzzleOpen) {
      _puzzleOpen = true;
      showPuzzleDialog(context, state.pendingPuzzle!, widget.controller)
          .whenComplete(() => _puzzleOpen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partida'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: widget.onExit,
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final state = widget.controller.state;
          final me = findMe(state, widget.myNickname);
          final myTurn = isMyTurn(state, me);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Rodada ${state.roundNumber}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Icon(
                      state.direction == GameDirection.horario
                          ? Icons.rotate_right
                          : Icons.rotate_left,
                    ),
                    const SizedBox(width: 8),
                    if (state.vira != null)
                      SizedBox(
                        width: 62,
                        height: 88,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text(
                                  state.vira!.valor.symbol,
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: state.vira!.naipe.color,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  state.vira!.naipe.symbol,
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: state.vira!.naipe.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              PlayersBar(
                players: state.players,
                currentPlayerId: state.currentPlayerId,
                myId: me?.id,
              ),
              Expanded(
                child: TablePlays(plays: state.plays),
              ),
              if (widget.controller.error != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.controller.error!.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 8),
              if (state.phase == GamePhase.aguardandoJogadores && me?.host == true)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FilledButton(
                    onPressed: widget.controller.busy ? null : widget.controller.start,
                    child: const Text('Iniciar partida'),
                  ),
                ),
              if (state.phase == GamePhase.entreRodadas)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FilledButton(
                    onPressed: widget.controller.busy ? null : widget.controller.ready,
                    child: const Text('Próxima rodada'),
                  ),
                ),
              if (state.phase == GamePhase.emAndamento ||
                  state.phase == GamePhase.entreRodadas)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: OutlinedButton(
                    onPressed: widget.controller.busy ? null : widget.controller.buyTrophy,
                    child: Text(
                      'Comprar troféu (${state.settings.trophyPrice} moedas)',
                    ),
                  ),
                ),
              if (me?.host == true &&
                  state.phase != GamePhase.finalizado &&
                  state.phase != GamePhase.cancelado)
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: TextButton(
                    onPressed: widget.controller.busy ? null : widget.controller.cancel,
                    child: const Text('Cancelar partida'),
                  ),
                ),
              if (state.phase == GamePhase.finalizado) ...[
                const SizedBox(height: 12),
                if (state.winnerPlayerId != null)
                  Builder(
                    builder: (context) {
                      final winner = state.players.firstWhere(
                        (player) => player.id == state.winnerPlayerId,
                        orElse: () => me ?? state.players.first,
                      );
                      return Text(
                        winner.nickname == widget.myNickname
                            ? 'Você venceu!'
                            : 'Vencedor: ${winner.nickname}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      );
                    },
                  ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FilledButton(
                    onPressed: widget.onExit,
                    child: const Text('Voltar ao menu'),
                  ),
                ),
              ] else if (state.phase == GamePhase.cancelado) ...[
                const SizedBox(height: 12),
                const Text('Partida cancelada'),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: FilledButton(
                    onPressed: widget.onExit,
                    child: const Text('Voltar ao menu'),
                  ),
                ),
              ] else ...[
                HandView(
                  hand: state.hand,
                  enabled: myTurn &&
                      !widget.controller.busy &&
                      state.roundStatus == RoundStatus.emAndamento,
                  onPlay: widget.controller.playCard,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
