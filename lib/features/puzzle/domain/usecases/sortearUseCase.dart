import '../entities/puzzle.dart';
import '../repositories/puzzleRepository.dart';

class SortearUseCase {
  final PuzzleRepository repository;

  SortearUseCase(this.repository);

  Future<Puzzle> Call(String id) {
    return repository.getPuzzleById(id);
  }
}