import 'package:http/http.dart';
import 'package:multiversx_api/multiversx_api.dart';
import 'package:multiversx_crypto/multiversx_crypto.dart';
import 'package:multiversx_sdk/multiversx_sdk.dart';

void main() async {
  final client = Client();
  final api = MultiverXApi(
    client: client,
    baseUrl: testnetApiBaseUrl,
  );
  final sdk = Sdk(
    api,
    networkConfiguration: DevnetNetworkConfiguration(),
  );

  final shard = [0, 1, 2];
  final relayers = <SigningKey>[];

  for (final shardId in shard) {
    while (relayers.length != shardId + 1) {
      final bip44 = Bip44.generate();
      var signingKey = await SigningKey.fromMnemonic(
        bip44.mnemonic,
      );
      final accountDetails =
          await api.accounts.getAccount(signingKey.publicKey.bech32);

      if (accountDetails.shard == shardId) {
        print('shard $shardId');
        print('\tmnemonic : ${bip44.mnemonic}');
        print('\taddress : ${signingKey.publicKey.bech32}');
        relayers.add(signingKey);
      }
    }
  }
}
