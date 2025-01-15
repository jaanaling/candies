import 'dart:math';
import 'package:flutter/foundation.dart';

// Статус ячейки: неизвестна, правильная, неправильная
enum CellStatus { unknown, correct, wrong }

// Класс, управляющий логикой ввода, проверкой и подсказками.
class RiddleLogic extends ChangeNotifier {
  final String answer;
  List<String> _currentInput;
  List<CellStatus> _cellStatus;

  RiddleLogic({required this.answer})
      : _currentInput = List.filled(answer.length, ''),
        _cellStatus = List.filled(answer.length, CellStatus.unknown);

  // Возвращаем текущее состояние букв
  List<String> get currentInput => List.unmodifiable(_currentInput);

  // Возвращаем статусы для отрисовки цвета ячеек
  List<CellStatus> get cellStatus => List.unmodifiable(_cellStatus);

  bool get isComplete => !_currentInput.contains('');

  // Обработчик нажатия на кнопку с буквой (английская клавиатура)
  void onLetterPressed(String letter) {
    // Находим первое незаполненное место
    final index = _currentInput.indexOf('');
    if (index != -1) {
      _currentInput[index] = letter;
      notifyListeners();
    }
  }

  // Обработчик удаления последней буквы (например, при нажатии Backspace)
  void onDeleteLetter() {
    // Находим последнюю заполненную ячейку
    final filledIndexes = _currentInput
        .asMap()
        .entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => e.key)
        .toList();
    if (filledIndexes.isNotEmpty) {
      final lastFilledIndex = filledIndexes.last;
      _currentInput[lastFilledIndex] = '';
      notifyListeners();
    }
  }

  // Подтверждение ответа
  // Проверяем каждую букву: если соответствует ответу, статус = correct, иначе wrong
  void onConfirm() {
    if (!isComplete) return; // нельзя подтверждать, если не все буквы введены
    for (int i = 0; i < answer.length; i++) {
      if (_currentInput[i].toLowerCase() == answer[i].toLowerCase()) {
        _cellStatus[i] = CellStatus.correct;
      } else {
        _cellStatus[i] = CellStatus.wrong;
      }
    }
    notifyListeners();
  }

  // Использование подсказки: открываем случайную неоткрытую букву
  // Под "неоткрытой" понимаем ячейку, которая еще не заполнена или заполнена неверно.
  // Если подсказка позволяет сразу поставить правильную букву, то меняем currentInput и статус на correct.
  void useHint() {
    // Список индексов ячеек, которые либо пустые, либо некорректно введены (wrong или unknown)
    final unopenedIndexes = <int>[];
    for (int i = 0; i < answer.length; i++) {
      if (_cellStatus[i] != CellStatus.correct) {
        // Если клетка неизвестна или неправильна, считаем её закрытой
        unopenedIndexes.add(i);
      }
    }

    if (unopenedIndexes.isEmpty) return; // Все уже правильные

    final randomIndex = unopenedIndexes[Random().nextInt(unopenedIndexes.length)];
    // Открываем эту букву
    _currentInput[randomIndex] = answer[randomIndex];
    _cellStatus[randomIndex] = CellStatus.correct;
    notifyListeners();
  }

  // Перезапуск (если надо, например при новой попытке):
  void reset() {
    _currentInput = List.filled(answer.length, '');
    _cellStatus = List.filled(answer.length, CellStatus.unknown);
    notifyListeners();
  }
}
