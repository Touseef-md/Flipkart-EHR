import 'package:flipkart_ehr/provider/account_keys_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../modal/eth_utils.dart';

class EthUtilsProvider extends StateNotifier<AsyncValue<int>> {
  final EthereumUtils ethUtil = EthereumUtils();
  final Ref ref;
  // ethUtil.
  EthUtilsProvider(this.ref) : super(AsyncValue.data(1)) {
    ethUtil.initialSetup();
  }
  Future<bool> getIsPatient() async {
    state = const AsyncValue.data(1);
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

  Future approveConsent(String hiuAddr) async {
    state = const AsyncValue.loading();
    print('INside the provider approveConsent func');
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.approveConsent(
        ref.read(AccountAddressProvider),
        ref.read(AccountPrivateKeyProvider),
        hiuAddr,
      );
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider approveConsent: ${err}');
      return false;
    }
  }

//Functions related to HIPs
  Future<bool> getIsHIP() async {
    state = const AsyncValue.loading();
    print('INside the provider getIsHIP func');
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.getIsHIP(ref.read(AccountAddressProvider));
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider getIsHIP: ${err}');
      return false;
    }
    // return false;
  }

  Future addNewHIP(String name, String email) async {
    state = const AsyncValue.loading();
    print('INside the provider addNewHIP func');
    // try {
    //   // print('Account address:${ref.read(AccountAddressProvider)}');
    //   final result = await ethUtil.addNewHIP(ref.read(AccountAddressProvider),
    //       ref.read(AccountPrivateKeyProvider), name, email);
    //   state = AsyncValue.data(1);
    //   // return false;
    //   return result;
    // } catch (err) {
    //   state = AsyncValue.error(err, StackTrace.current);
    //   print('Error inside the EthProvider addNewHIP: ${err}');
    //   return false;
    // }
  }

  //Functions related to HIUs
  Future<bool> getIsHIU() async {
    state = const AsyncValue.loading();
    print('INside the provider getIsHIU func');
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.getIsHIU(ref.read(AccountAddressProvider));
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider getIsHIU: ${err}');
      return false;
    }
    // return false;
  }

  Future addNewHIU(String name, String email) async {
    state = const AsyncValue.loading();
    print('INside the provider addNewHIU func');
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.addNewHIU(ref.read(AccountAddressProvider),
          ref.read(AccountPrivateKeyProvider), name, email);
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider addNewHIU: ${err}');
      return false;
    }
  }

  Future getHIU() async {
    state = const AsyncValue.loading();
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.getHIU(ref.read(AccountAddressProvider));
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider getHIU: ${err}');
      // return false;
    }
  }

  Future hasConsent(
    String patientAddr,
  ) async {
    state = const AsyncValue.loading();
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.hasConsent(
          ref.read(AccountAddressProvider), patientAddr);
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider hasConsent: ${err}');
      return false;
    }
  }

  Future requestRecords(String patientAddr) async {
    state = const AsyncValue.loading();
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.requestRecords(
          ref.read(AccountAddressProvider), patientAddr);
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider hasConsent: ${err}');
      return false;
    }
  }

  Future addRecord(String patientAddr) async {
    state = const AsyncValue.loading();
    print(patientAddr);
    try {
      // print('Account address:${ref.read(AccountAddressProvider)}');
      final result = await ethUtil.addRecord(ref.read(AccountAddressProvider),
          ref.read(AccountPrivateKeyProvider), patientAddr);
      state = AsyncValue.data(1);
      // return false;
      return result;
    } catch (err) {
      state = AsyncValue.error(err, StackTrace.current);
      print('Error inside the EthProvider addRecord: ${err}');
      return false;
    }
  }
}

final ethUtilsNotifierProvider =
    StateNotifierProvider<EthUtilsProvider, AsyncValue<int>>(
        (ref) => EthUtilsProvider(ref));
