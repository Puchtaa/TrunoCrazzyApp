import 'package:flutter/foundation.dart';

import '../../../../core/error/app_exception.dart';
import '../../../auth/domain/entities/auth_session.dart';
import '../../../ranking/domain/usecases/get_ranking_usecase.dart';
import '../state/profile_state.dart';

class ProfileController extends ChangeNotifier {
  final GetRankingUseCase _getRanking;

  ProfileController(this._getRanking, AuthSession session)
      : _state = ProfileState.idle(session);

  ProfileState _state;
  ProfileState get state => _state;

  Future<void> refresh() async {
    if (_state.isLoading) return;

    _emit(_state.loading());
    try {
      final entries = await _getRanking();
      final index =
          entries.indexWhere((entry) => entry.id == _state.session.user.id);

      _emit(
        _state.success(
          points: index < 0
              ? _state.session.user.rankingPoints
              : entries[index].rankingPoints,
          position: index < 0 ? null : index + 1,
        ),
      );
    } on AppException catch (error) {
      _emit(_state.failure(error));
    } catch (error) {
      _emit(_state.failure(UnexpectedException(cause: error)));
    }
  }

  void _emit(ProfileState state) {
    _state = state;
    notifyListeners();
  }
}
