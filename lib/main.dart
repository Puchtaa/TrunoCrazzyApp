import 'package:flutter/material.dart';
import 'package:trunocrazy/features/ranking/data/repositories/ranking_repository_impl.dart';
import 'package:trunocrazy/features/ranking/domain/usecases/get_ranking_usecase.dart';

import 'core/network/api_client.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/data/repositories/session_repository_impl.dart';
import 'features/auth/domain/entities/auth_session.dart';
import 'features/auth/domain/usecases/clear_session_usecase.dart';
import 'features/auth/domain/usecases/get_current_session_usecase.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/presentation/controllers/login_controller.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/catalog/data/repositories/card_catalog_repository_impl.dart';
import 'features/catalog/domain/usecases/list_cards_usecase.dart';
import 'features/game/data/repositories/game_repository_impl.dart';
import 'features/game/domain/usecases/access_game_usecase.dart';
import 'features/game/domain/usecases/answer_puzzle_usecase.dart';
import 'features/game/domain/usecases/buy_trophy_usecase.dart';
import 'features/game/domain/usecases/cancel_game_usecase.dart';
import 'features/game/domain/usecases/create_game_usecase.dart';
import 'features/game/domain/usecases/get_game_state_usecase.dart';
import 'features/game/domain/usecases/play_card_usecase.dart';
import 'features/game/domain/usecases/ready_for_next_round_usecase.dart';
import 'features/game/domain/usecases/start_game_usecase.dart';
import 'features/home/presentation/home_page.dart';
void main() => runApp(const TrunoCrazyApp());

class TrunoCrazyApp extends StatefulWidget {
  const TrunoCrazyApp({super.key});

  @override
  State<TrunoCrazyApp> createState() => _TrunoCrazyAppState();
}

class _TrunoCrazyAppState extends State<TrunoCrazyApp> {
  late final SessionRepositoryImpl _sessions;
  late final ApiClient _api;
  late final LoginUseCase _login;
  late final GetCurrentSessionUseCase _getSession;
  late final ClearSessionUseCase _clearSession;
  late final ListCardsUseCase _listCards;
  late final GetRankingUseCase _getRanking;
  late final GameRepositoryImpl _gameRepository;
  late final CreateGameUseCase _createGame;
  late final AccessGameUseCase _accessGame;
  late final GetGameStateUseCase _getGameState;
  late final StartGameUseCase _startGame;
  late final PlayCardUseCase _playCard;
  late final AnswerPuzzleUseCase _answerPuzzle;
  late final BuyTrophyUseCase _buyTrophy;
  late final ReadyForNextRoundUseCase _readyForNextRound;
  late final CancelGameUseCase _cancelGame;

  AuthSession? _session;
  bool _loading = true;
  LoginController? _loginController;

  @override
  void initState() {
    super.initState();
    _sessions = const SessionRepositoryImpl();
    _api = ApiClient(
      tokenProvider: () async => (await _sessions.getCurrentSession())?.token,
      onUnauthorized: _logout,
    );
    _login = LoginUseCase(AuthRepositoryImpl(_api), _sessions);
    _getSession = GetCurrentSessionUseCase(_sessions);
    _clearSession = ClearSessionUseCase(_sessions);
    _listCards = ListCardsUseCase(CardCatalogRepositoryImpl(_api));
    _getRanking = GetRankingUseCase(RankingRepositoryImpl(_api));
    _gameRepository = GameRepositoryImpl(_api);
    _createGame = CreateGameUseCase(_gameRepository);
    _accessGame = AccessGameUseCase(_gameRepository);
    _getGameState = GetGameStateUseCase(_gameRepository);
    _startGame = StartGameUseCase(_gameRepository);
    _playCard = PlayCardUseCase(_gameRepository);
    _answerPuzzle = AnswerPuzzleUseCase(_gameRepository);
    _buyTrophy = BuyTrophyUseCase(_gameRepository);
    _readyForNextRound = ReadyForNextRoundUseCase(_gameRepository);
    _cancelGame = CancelGameUseCase(_gameRepository);
    _restore();
  }

  Future<void> _restore() async {
    final session = await _getSession();
    if (!mounted) return;
    setState(() {
      _session = session;
      _loading = false;
    });
  }

  Future<void> _logout() async {
    await _clearSession();
    if (!mounted) return;
    setState(() {
      _session = null;
      _loginController = LoginController(_login);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget home;
    if (_loading) {
      home = const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (_session == null) {
      _loginController ??= LoginController(_login);
      home = LoginPage(
        controller: _loginController!,
        onLoggedIn: (session) => setState(() => _session = session),
      );
    } else {
      home = HomePage(
        session: _session!,
        onLogout: _logout,
        listCards: _listCards,
        getRanking: _getRanking,
        createGame: _createGame,
        accessGame: _accessGame,
        getGameState: _getGameState,
        startGame: _startGame,
        playCard: _playCard,
        answerPuzzle: _answerPuzzle,
        buyTrophy: _buyTrophy,
        ready: _readyForNextRound,
        cancelGame: _cancelGame,
      );
    }

    return MaterialApp(
      title: 'TrunoCrazy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6C1906)),
        useMaterial3: true,
      ),
      home: home,
    );
  }
}
