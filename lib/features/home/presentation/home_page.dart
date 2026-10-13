import 'package:flutter/material.dart';
import 'package:trunocrazy/features/profile/presentation/controllers/profile_controller.dart';
import 'package:trunocrazy/features/profile/presentation/pages/profile_page.dart';
import 'package:trunocrazy/features/ranking/domain/usecases/get_ranking_usecase.dart';

import '../../auth/domain/entities/auth_session.dart';
import '../../catalog/domain/usecases/list_cards_usecase.dart';
import '../../catalog/presentation/pages/catalogo_page.dart';
import '../../game/domain/usecases/access_game_usecase.dart';
import '../../game/domain/usecases/answer_puzzle_usecase.dart';
import '../../game/domain/usecases/buy_trophy_usecase.dart';
import '../../game/domain/usecases/cancel_game_usecase.dart';
import '../../game/domain/usecases/create_game_usecase.dart';
import '../../game/domain/usecases/get_game_state_usecase.dart';
import '../../game/domain/usecases/play_card_usecase.dart';
import '../../game/domain/usecases/ready_for_next_round_usecase.dart';
import '../../game/domain/usecases/start_game_usecase.dart';
import '../../lobby/presentation/controllers/lobby_controller.dart';
import '../../lobby/presentation/pages/lobby_page.dart';
import '../../game/presentation/controllers/game_controller.dart';
import '../../game/presentation/pages/game_page.dart';

/// Contêiner autenticado: desenha a dock e troca o corpo conforme a aba.
///
/// A aba inicial é a Home. Para ligar uma nova tela, preencha o `builder`
/// da aba correspondente em [_HomePageState._tabs]; enquanto ele for `null`,
/// a aba mostra um aviso de "em breve".
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.session,
    required this.onLogout,
    required this.listCards,
    required this.getRanking,
    required this.createGame,
    required this.accessGame,
    required this.getGameState,
    required this.startGame,
    required this.playCard,
    required this.answerPuzzle,
    required this.buyTrophy,
    required this.ready,
    required this.cancelGame,
  });

  final AuthSession session;
  final VoidCallback onLogout;
  final ListCardsUseCase listCards;
  final GetRankingUseCase getRanking;
  final CreateGameUseCase createGame;
  final AccessGameUseCase accessGame;
  final GetGameStateUseCase getGameState;
  final StartGameUseCase startGame;
  final PlayCardUseCase playCard;
  final AnswerPuzzleUseCase answerPuzzle;
  final BuyTrophyUseCase buyTrophy;
  final ReadyForNextRoundUseCase ready;
  final CancelGameUseCase cancelGame;

  @override
  State<HomePage> createState() => _HomePageState();
}

/// Índices das abas, na mesma ordem de [_HomePageState._tabs].
abstract final class _Tab {
  static const home = 0;
  static const play = 1;
  static const catalog = 2;
  static const ranking = 3;
}

class _HomePageState extends State<HomePage> {
  int _selected = _Tab.home;

  /// Abas já visitadas. Só são montadas na primeira visita, para que nenhuma
  /// tela consulte a API antes de ser aberta.
  final Set<int> _visited = {_Tab.home};

  late final LobbyController _lobbyController = LobbyController(
    create: widget.createGame,
    access: widget.accessGame,
  );

  List<_DockTab> get _tabs => [
    _DockTab(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      builder: (_) => _HomeContent(
        session: widget.session,
        onLogout: widget.onLogout,
        onSelectTab: _select,
      ),
    ),
    _DockTab(
      label: 'Jogar',
      icon: Icons.play_circle_outline,
      selectedIcon: Icons.play_circle,
      builder: (_) => LobbyPage(
        controller: _lobbyController,
        onGameReady: _openGame,
      ),
    ),
    _DockTab(
      label: 'Catálogo',
      icon: Icons.style_outlined,
      selectedIcon: Icons.style,
      builder: (_) => CatalogoPage(listCards: widget.listCards),
    ),
    const _DockTab(
      label: 'Ranking',
      icon: Icons.leaderboard_outlined,
      selectedIcon: Icons.leaderboard,
      // TODO: builder: (_) => RankingPage(...)
    ),
    _DockTab(
      label: 'Perfil',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      builder: (_) => ProfilePage(
        controller: ProfileController(widget.getRanking, widget.session),
        onLogout: () async => widget.onLogout(),
      ),
    ),
  ];

  void _openGame(game) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GamePage(
          controller: GameController(
            initial: game,
            getState: widget.getGameState,
            startGame: widget.startGame,
            playCard: widget.playCard,
            answerPuzzle: widget.answerPuzzle,
            buyTrophy: widget.buyTrophy,
            ready: widget.ready,
            cancelGame: widget.cancelGame,
          ),
          myNickname: widget.session.user.nickname,
          onExit: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  void _select(int index) {
    if (index == _selected) return;
    setState(() {
      _selected = index;
      _visited.add(index);
    });
  }

  @override
  void dispose() {
    _lobbyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selected,
        children: [
          for (var i = 0; i < _tabs.length; i++)
            _visited.contains(i) ? _tabs[i].build(context) : const SizedBox(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        height: 64,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        selectedIndex: _selected,
        onDestinationSelected: _select,
        destinations: [
          for (final tab in _tabs)
            NavigationDestination(
              icon: Icon(tab.icon),
              selectedIcon: Icon(tab.selectedIcon),
              label: tab.label,
            ),
        ],
      ),
    );
  }
}

/// Descrição de um botão da dock e da tela que ele abre.
class _DockTab {
  const _DockTab({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.builder,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  /// Tela da aba. `null` enquanto a tela ainda não foi implementada.
  final WidgetBuilder? builder;

  Widget build(BuildContext context) =>
      builder?.call(context) ?? _PendingTab(label: label, icon: selectedIcon);
}

/// Corpo da aba Home: saudação, pontos e atalhos para as outras abas.
class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.session,
    required this.onLogout,
    required this.onSelectTab,
  });

  final AuthSession session;
  final VoidCallback onLogout;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Olá, ${session.user.nickname}',
                  style: theme.textTheme.titleLarge,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: 'Sair',
                icon: const Icon(Icons.logout),
                onPressed: onLogout,
              ),
            ],
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.emoji_events),
              title: const Text('Pontos de ranking'),
              trailing: Text(
                '${session.user.rankingPoints}',
                style: theme.textTheme.titleMedium,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            onPressed: () => onSelectTab(_Tab.play),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Jogar'),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onSelectTab(_Tab.ranking),
                  icon: const Icon(Icons.leaderboard_outlined),
                  label: const Text('Ranking'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => onSelectTab(_Tab.catalog),
                  icon: const Icon(Icons.style_outlined),
                  label: const Text('Catálogo'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Placeholder das abas cuja tela ainda não foi informada.
class _PendingTab extends StatelessWidget {
  const _PendingTab({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 8),
            Text(label, style: theme.textTheme.titleMedium),
            Text('Em breve', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
