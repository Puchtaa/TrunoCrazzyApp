import '../entities/puzzle.dart';

abstract interface class PuzzleRepository {
  Future<Puzzle> getPuzzleById(String id);
  Future<List<Puzzle>> PostResponsePuzzle(int alternativaEscolhida);
  Future<Puzzle> getRandomPuzzle();
  Future<List<Puzzle>> getPuzzles();
  Future<List<Puzzle>> getPuzzleByCategory(String category);
  Future<List<Puzzle>> getPuzzleByDifficulty(String difficulty);
}