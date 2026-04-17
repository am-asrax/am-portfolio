# am_portfolio_client.api.MarketIndexApi

## Load the API package
```dart
import 'package:am_portfolio_client/api.dart';
```

All URIs are relative to *http://localhost:8060*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getAllMarketIndices**](MarketIndexApi.md#getallmarketindices) | **GET** /api/v1/market-index/all | Get all market indices


# **getAllMarketIndices**
> BuiltList<IndexIndices> getAllMarketIndices(interval, type)

Get all market indices

### Example
```dart
import 'package:am_portfolio_client/api.dart';

final api = AmPortfolioClient().getMarketIndexApi();
final String interval = interval_example; // String | 
final String type = type_example; // String | 

try {
    final response = api.getAllMarketIndices(interval, type);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MarketIndexApi->getAllMarketIndices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **interval** | **String**|  | [optional] 
 **type** | **String**|  | [optional] 

### Return type

[**BuiltList&lt;IndexIndices&gt;**](IndexIndices.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

