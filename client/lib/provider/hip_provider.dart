import 'package:flutter_riverpod/flutter_riverpod.dart';

class HIPProvider extends StateNotifier<AsyncValue<int>> {
  final Ref ref;
  HIPProvider(this.ref) : super(AsyncValue.data(1));
  Future sendRecord() async {
    try {
      state = AsyncValue.loading();
      
      state = AsyncValue.data(1);
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
    }
  }
}

final hiuNotifierProvider = StateNotifierProvider<HIPProvider, AsyncValue<int>>(
    (ref) => HIPProvider(ref));
