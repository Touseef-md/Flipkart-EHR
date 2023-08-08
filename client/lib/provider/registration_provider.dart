import 'package:flutter_riverpod/flutter_riverpod.dart';

class Registration extends StateNotifier<AsyncValue<int>> {
  Registration() : super(AsyncValue.loading());


}

final registrationNotifierProvider =
    StateNotifierProvider<Registration, AsyncValue<int>>(
  (ref) {
    return Registration();
  },
);
