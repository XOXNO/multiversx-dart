import 'package:http/http.dart';
import 'package:multiversx_api/multiversx_api.dart';
import 'package:multiversx_crypto/multiversx_crypto.dart';
import 'package:multiversx_sdk/multiversx_sdk.dart';

import '../mnemonic.dart';

// This code demonstrates how to create and send a relayed ESDT transaction on the MultiversX blockchain
void main() async {
  // Initialize HTTP client and MultiversX API for devnet
  final client = Client();
  final api = MultiverXApi(
    client: client,
    baseUrl: devnetApiBaseUrl,
  );
  final networkConfiguration = DevnetNetworkConfiguration();
  final sdk = Sdk(
    api,
    networkConfiguration: networkConfiguration,
  );

  // Set the receiver's address
  final receiver = PublicKey.fromBech32(
    'erd10ugfytgdndw5qmnykemjfpd7xrjs63f0r2qjhug0ek9gnfdjxq4s8qjvcx',
  );

  final mainWallet = await Wallet.fromMnemonic(mnemonic: mnemonic);
  final relayerMnemonic =
      'swamp demise physical vacant void sword win apple stem toss whisper shine female develop veteran harsh tuition amount plate empower market reflect dizzy pen';
  final relayerWallet =
      await Wallet.fromMnemonic(mnemonic: relayerMnemonic, isRelayer: true);

  final walletPair = WalletPair(mainWallet, relayerWallet: relayerWallet);

  final accountDetails =
      await api.accounts.getAccount(walletPair.mainWallet.publicKey.bech32);
  final nonce = Nonce(accountDetails.nonce);

  final relayerAddress = walletPair.relayerWallet.publicKey;

  // Create the inner ESDT transaction with 1 XOXNO amount
  final transaction = EgldTransferTransaction(
    networkConfiguration: networkConfiguration,
    value: Balance.fromEgld(0.1),
    nonce: nonce,
    receiver: receiver,
    sender: walletPair.mainWallet.publicKey,
    relayer: relayerAddress,
    additionnalGasLimit: const GasLimit(50000),
  );

  // Sign the relayed transaction with relayer wallet
  final signedRelayedTransaction = sdk.signTransaction(
    walletPair: walletPair,
    transaction: transaction,
  );
  try {
    // Send the signed relayed transaction
    final transactionResponse = await sdk.sendSignedTransaction(
      signedTransaction: signedRelayedTransaction,
    );
    print(transactionResponse.toJson());
  } on ApiException catch (e) {
    print(e.statusCode);
    print(e.message);
    print(e.error);
  } finally {
    client.close();
  }
}
