import 'package:flutter/material.dart';
import '../models/drawing_point.dart';

class MemoProvider extends ChangeNotifier {
  List<DrawingPoint?> _points = [];
  List<DrawingPoint?> _eraserPoints = [];
  List<List<DrawingPoint?>> _undoStack = [];
  List<List<DrawingPoint?>> _eraserUndoStack = [];
  bool _isEraserMode = false;

  List<DrawingPoint?> get points => _points;
  List<DrawingPoint?> get eraserPoints => _eraserPoints;
  bool get isEraserMode => _isEraserMode;

  void addPoint(DrawingPoint? point) {
    _points.add(point);
    notifyListeners();
  }

  void addEraserPoint(DrawingPoint? point) {
    _eraserPoints.add(point);
    notifyListeners();
  }

  void clearPoints() {
    _points.clear();
    notifyListeners();
  }

  void clearEraserPoints() {
    _eraserPoints.clear();
    notifyListeners();
  }

  void setEraserMode(bool value) {
    _isEraserMode = value;
    notifyListeners();
  }

  void saveToUndoStack() {
    _undoStack.add(List.from(_points));
    _eraserUndoStack.add(List.from(_eraserPoints));
    notifyListeners();
  }

  void undo() {
    if (_undoStack.isNotEmpty) {
      _points = _undoStack.removeLast();
      _eraserPoints = _eraserUndoStack.removeLast();
      notifyListeners();
    }
  }

  void clearAll() {
    _points.clear();
    _eraserPoints.clear();
    _undoStack.clear();
    _eraserUndoStack.clear();
    _isEraserMode = false;
    notifyListeners();
  }
} 