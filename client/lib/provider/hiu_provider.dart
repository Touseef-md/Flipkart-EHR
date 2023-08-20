import 'package:flipkart_ehr/modal/hiu.dart';
import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flipkart_ehr/provider/eth_utils_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HIUProvider extends StateNotifier<AsyncValue<int>> {
  late final HIU hiu;
  final Ref ref;
  HIUProvider(this.ref) : super(AsyncValue.data(1));

  Future addNewHIU(String name, String email) async {
    state = const AsyncValue.loading();
    hiu = HIU(
        address: ref.read(AccountAddressProvider), name: name, email: email);
    state = AsyncValue.data(1);
  }

  Future requestRecords(String patientAddr) async {
    state = const AsyncValue.loading();

    try {
      final result = await ref
          .read(ethUtilsNotifierProvider.notifier)
          .requestRecords(patientAddr);
      print('These are the list of HIPS${result}');
      return result;
      state = AsyncValue.data(1);
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the HIUProvider addNewHIU: ${err}');
    }
  }

  Future getHIU() async {
    state = const AsyncValue.loading();

    try {
      final result =
          await ref.read(ethUtilsNotifierProvider.notifier).getHIU() as List;
      if (result != null) {
        hiu = HIU(
          address: ref.read(AccountAddressProvider),
          name: result[0],
          email: result[1],
        );
      }
      state = AsyncValue.data(1);
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the HIUProvider addNewHIU: ${err}');
    }
  }
}

final hiuNotifierProvider = StateNotifierProvider<HIUProvider, AsyncValue<int>>(
    (ref) => HIUProvider(ref));
