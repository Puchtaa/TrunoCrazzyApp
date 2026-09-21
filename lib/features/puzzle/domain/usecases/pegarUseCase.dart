import '../entities/puzzle.dart';
import '../repositories/puzzleRepository.dart';

class ResponderUseCase {
  final PuzzleRepository repository;

  const ResponderUseCase(this.repository);

  Future<List<Puzzle>> Call(int alternativaCorreta) {
    return repository.PostResponsePuzzle(alternativaCorreta);
  }
}

