import 'package:test/test.dart';
import 'package:am_portfolio_client/am_portfolio_client.dart';


/// tests for MarketIndexApi
void main() {
  final instance = AmPortfolioClient().getMarketIndexApi();

  group(MarketIndexApi, () {
    // Get all market indices
    //
    //Future<BuiltList<IndexIndices>> getAllMarketIndices({ String interval, String type }) async
    test('test getAllMarketIndices', () async {
      // TODO
    });

  });
}
