import 'package:flutter/cupertino.dart';
import 'package:english_words/english_words.dart';

class AppState extends ChangeNotifier {
  var current = WordPair.random();
}