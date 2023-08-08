import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modal/eth_utils.dart';

class EthUtilsProvider extends StateNotifier<AsyncValue<int>> {
  final EthereumUtils ethUtil = EthereumUtils();
  final Ref ref;
  // ethUtil.
  EthUtilsProvider(this.ref) : super(AsyncValue.loading()) {
    ethUtil.initialSetup();
  }
  Future<bool> getIsPatient() async {
    state = const AsyncValue.loading();
    print('INside the provider has record func ');
    try {
      print('Account address:${ref.read(AccountAddressProvider)}');
      final isPatient =
          await ethUtil.getIsPatient(ref.read(AccountAddressProvider));
      state = AsyncValue.data(1);
      // return false;
      return isPatient;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider getIsPatient: ${err}');
      return false;
    }
    // return false;
  }

  Future checkPatientAgainstAadhar(String aadhaarNum) async {
    state = const AsyncValue.loading();
    print('INside the provider checkPatientAgainstAadhar func ');
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final isPatientWithDiffAddr = await ethUtil.checkAadharAgainstAddress(
          ref.read(AccountAddressProvider), aadhaarNum);
      state = AsyncValue.data(1);
      // return false;
      return isPatientWithDiffAddr;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider checkPatientAgainstAadhar: ${err}');
      return false;
    }
  }

  Future addNewPatient(String aadhaarNum) async {
    state = const AsyncValue.loading();
    print('INside the provider addNewPatient func ');
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.addNewPatient(
        ref.read(AccountAddressProvider),
        aadhaarNum,
        ref.read(AccountPrivateKeyProvider),
      );
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider: ${err}');
      return false;
    }
  }
}

final ethUtilsNotifierProvider =
    StateNotifierProvider<EthUtilsProvider, AsyncValue<int>>(
        (ref) => EthUtilsProvider(ref));
