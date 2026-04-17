import 'package:test/test.dart';
import 'package:am_portfolio_client/am_portfolio_client.dart';


/// tests for PortfolioApi
void main() {
  final instance = AmPortfolioClient().getPortfolioApi();

  group(PortfolioApi, () {
    // Get portfolio analysis
    //
    //Future<PortfolioAnalysis> getPortfolioAnalysis(String portfolioId, String userId, { TimeInterval interval }) async
    test('test getPortfolioAnalysis', () async {
      // TODO
    });

    // Get portfolio by ID
    //
    //Future<PortfolioModelV1> getPortfolioById(String portfolioId) async
    test('test getPortfolioById', () async {
      // TODO
    });

    // Get all portfolios for a user
    //
    //Future<BuiltList<PortfolioModelV1>> getPortfolios(String userId) async
    test('test getPortfolios', () async {
      // TODO
    });

  });
}
