import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EthereumUtils {
  late http.Client httpClient;
  late Web3Client ethClient;
  final contractAddress = dotenv.env['CONTRACT_ADDRESS'];
  void initialSetup() {
    httpClient = http.Client();
    String infura =
        'https://${dotenv.env['CHAIN_NAME']}.infura.io/v3/${dotenv.env['INFURA_API_KEY']}';
    ethClient = Web3Client(infura, httpClient);
  }

  Future waitForConfirmation(String txHash) async {
    try {
      TransactionReceipt? receipt;
      do {
        await Future.delayed(Duration(seconds: 5));
        receipt = await ethClient.getTransactionReceipt(txHash);
      } while (receipt == null);

      if (receipt.status == true) {
        // The transaction has been successfully confirmed and included in a block
        print('Transaction confirmed');
        print('Block number: ${receipt.blockNumber}');

        // Call your function here after the transaction is confirmed
        // yourFunctionAfterConfirmation();
        return true;
      } else {
        // The transaction failed and was not included in a block
        print('Transaction failed');
        return false;
        // print('Error message: ${receipt.error}');

        // Handle the failure or retry if needed
      }
    } catch (e) {
      // Handle any errors that occurred during the request
      print('Error checking transaction status: $e');
      return false;
    }
  }

  Future callViewFunction(String functionName, List para) async {
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function(functionName);
      final result = await ethClient.call(
        contract: contract,
        function: ethFunction,
        params: para,
      );
      print(
          'Result while calling contract function ${functionName}: ${result}');
      return result;
    } catch (err) {
      print('Error while calling the contract function: ${err}');
      return false;
    }
  }

  Future callTxFunction(String functionName, String callerAddress, List params,
      String privateKey) async {
    try {
      var contract = await getDeployedContract();
      final ethFunction = contract.function(functionName);
      final credential = EthPrivateKey.fromHex(privateKey);
      // print('doing tx...');

      // var add = EthereumAddress.fromHex(callerAddress);
      // print('check');
      Transaction tx = Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: params,
        from: EthereumAddress.fromHex(callerAddress),
        gasPrice: EtherAmount.inWei(
          BigInt.from(
            500000000,
          ),
        ),
      );

      final result = await ethClient.sendTransaction(
        credential,
        tx,
        chainId: null,
        fetchChainIdFromNetworkId: true,
      );
      print('Result when tx sent:${result}');
      if (await waitForConfirmation(result)) {
        return result;
      } else {
        // return false;
        throw Exception(
            'Error while waiting for tx confirmation of function:${functionName}');
      }
    } catch (err) {
      print('Error while calling function- ${functionName} : ${err}');
      return false;
    }
  }

  Future getIsPatient(String callerAddress) async {
    print('GEtis Patient called...');
    final result = await callViewFunction(
        'getIsPatient', [EthereumAddress.fromHex(callerAddress)]);
    print('Result of getIsPatient:${result}');
    return result[0];
  }

  Future checkAadharAgainstAddress(
      String callerAddress, String aadharNum) async {
    final result =
        await callViewFunction('checkPatientAgainstAadhar', [aadharNum]);
    print('Result of checkAadharAgainstAddress ethUtil :${result}');
    return result[0];
  }

  Future addNewPatient(
      String callerAddress, String aadhaarNum, String privateKey) async {
    final result = await callTxFunction('addNewPatient', callerAddress,
        [EthereumAddress.fromHex(callerAddress), aadhaarNum], privateKey);
    print('Result of addNewPatient ethUtil :${result}');
    return result;
  }

  Future<DeployedContract> getDeployedContract() async {
    // var abi=await rootBundle
    var abi = await rootBundle.loadString('assets/abi.json');
    final contract = DeployedContract(
      ContractAbi.fromJson(abi.toString(), 'FlipkartEhr'),
      EthereumAddress.fromHex(contractAddress!),
    );
    return contract;
  }
}
