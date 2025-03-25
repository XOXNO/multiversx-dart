import 'package:multiversx_crypto/multiversx_crypto.dart';
import 'package:multiversx_sdk/src/wallet.dart';

void main() async {
  final bip44 = Bip44.generate();
  // Generate a new wallet with a random mnemonic
  final wallet = await Wallet.fromMnemonic(
    mnemonic: bip44.mnemonic,
  );

  // Get the mnemonic for the generated wallet
  final mnemonic = wallet.mnemonic;

  // Get the public key (address) in bech32 format
  final publicKey = wallet.publicKey.bech32;

  // Print the wallet details
  print('New wallet generated successfully!');
  print('-------------------------------------------------------');
  print('Mnemonic (keep this secret and backup safely):');
  print(mnemonic);
  print('-------------------------------------------------------');
  print('Public Key (wallet address):');
  print(publicKey);
  print('-------------------------------------------------------');
  print('Warning: Never share your mnemonic with anyone!');
}
