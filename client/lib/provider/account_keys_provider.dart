import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// class AccountKeysProvider extends Provider{

// }
final AccountAddressProvider = StateProvider<String>((ref) {
  return dotenv.env['ACCOUNT_ADDRESS']!;
});
final AccountPrivateKeyProvider = StateProvider<String>(
  (ref) {
    return dotenv.env['PRIVATE_KEY']!;
  },
);
