import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/enums/game_phase.dart';
import '../../domain/usecases/answer_puzzle_usecase.dart';
import '../../domain/usecases/buy_trophy_usecase.dart';
import '../../domain/usecases/cancel_game_usecase.dart';
import '../../domain/usecases/get_game_state_usecase.dart';
import '../../domain/usecases/play_card_usecase.dart';
import '../../domain/usecases/ready_for_next_round_usecase.dart';
import '../../domain/usecases/start_game_usecase.dart';

class GameController extends ChangeNotifier {
  GameController({
    required GameState initial,
    required GetGameStateUseCase getState,
    required StartGameUseCase startGame,
    required PlayCardUseCase playCard,
    required AnswerPuzzleUseCase answerPuzzle,
    required BuyTrophyUseCase buyTrophy,
    required ReadyForNextRoundUseCase ready,
    required CancelGameUseCase cancelGame,
  })  : _state = initial,
        _getState = getState,
        _startGame = startGame,
        _playCard = playCard,
        _answerPuzzle = answerPuzzle,
        _buyTrophy = buyTrophy,
        _ready = ready,
        _cancelGame = cancelGame;

  final GetGameStateUseCase _getState;
  final StartGameUseCase _startGame;
  final PlayCardUseCase _playCard;
  final AnswerPuzzleUseCase _answerPuzzle;
  final BuyTrophyUseCase _buyTrophy;
  final ReadyForNextRoundUseCase _ready;
  final CancelGameUseCase _cancelGame;

  GameState _state;
  GameState get state => _state;

  AppException? error;
  bool busy = false;

  Timer? _timer;
  bool _polling = false;
  bool _disposed = false;

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _poll());
  }

  void stopPolling() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _poll() async {
    if (_polling || busy) return;
    _polling = true;
    try {
      _apply(await _getState(_state.id));
    } on AppException catch (e) {
      error = e;
      _notify();
    } finally {
      _polling = false;
    }
  }

  void _apply(GameState next) {
    if (next.stateVersion <= _state.stateVersion) return;
    _state = next;
    error = null;
    if (next.phase == GamePhase.finalizado || next.phase == GamePhase.cancelado) {
      stopPolling();
    }
    _notify();
  }

  Future<void> start() => _act(() => _startGame(_state.id));
  Future<void> playCard(int handCardId) =>
      _act(() => _playCard(_state.id, handCardId));
  Future<void> answerPuzzle(int challengeId, int index) =>
      _act(() => _answerPuzzle(_state.id, challengeId, index));
  Future<void> buyTrophy() => _act(() => _buyTrophy(_state.id));
  Future<void> ready() => _act(() => _ready(_state.id));
  Future<void> cancel() => _act(() => _cancelGame(_state.id));

  Future<void> _act(Future<GameState> Function() action) async {
    if (busy) return;
    busy = true;
    error = null;
    _notify();
    try {
      _apply(await action());
    } on ConflictException catch (e) {
      error = e;
      await _refresh();
    } on AppException catch (e) {
      error = e;
    } catch (e) {
      error = UnexpectedException(cause: e);
    } finally {
      busy = false;
      _notify();
    }
  }

  Future<void> _refresh() async {
    try {
      _apply(await _getState(_state.id));
    } on AppException {
      // o polling tenta de novo
    }
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    stopPolling();
    super.dispose();
  }
}
