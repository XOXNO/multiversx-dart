import 'dart:convert';

import 'package:multiversx_crypto/multiversx_crypto.dart';
import 'package:multiversx_sdk/multiversx_sdk.dart';

import 'mnemonic.dart';

void main() async {
  final signingKey = await SigningKey.fromMnemonic(mnemonic);

  final message = utf8.encode(
      '{"nonce":27,"value":"100000000000000000","receiver":"erd10ugfytgdndw5qmnykemjfpd7xrjs63f0r2qjhug0ek9gnfdjxq4s8qjvcx","sender":"erd1qsnaz30h4c6fdn9q752kmjt57zwmgl5qg27r4jswwpj6vt3rsjyqsjck4k","gasPrice":1000000000,"gasLimit":100000,"chainID":"D","version":1,"relayer":"erd1kgryelf8xkrmx9y8mvdwvwsaexgynk5tprnsjd457ckn3rqjz79qgghkal"}');
  final signature = Signature(
      '1ef399a91eeb42775c613bf2a54af26bc1cf8815a3f4e8b5aed75c2bba3db4483e0ecf7f0586b49cdebde0cc0e214bd84eecdf9fb658477d3d0cb7c8a5c2fa06');

  final result = signingKey.verify(message, signature.bytes);
  print('Verification result: $result');
}
