
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingState extends StateNotifier<bool> {
  LoadingState() : super(false);
  
  void startLoading() => state = true;
  void stopLoading() => state = false;
}