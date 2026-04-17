# am_portfolio_client.api.PortfolioApi

## Load the API package
```dart
import 'package:am_portfolio_client/api.dart';
```

All URIs are relative to *http://localhost:8060*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getPortfolioAnalysis**](PortfolioApi.md#getportfolioanalysis) | **GET** /api/v1/portfolios/{portfolioId}/analysis | Get portfolio analysis
[**getPortfolioById**](PortfolioApi.md#getportfoliobyid) | **GET** /api/v1/portfolios/{portfolioId} | Get portfolio by ID
[**getPortfolios**](PortfolioApi.md#getportfolios) | **GET** /api/v1/portfolios | Get all portfolios for a user


# **getPortfolioAnalysis**
> PortfolioAnalysis getPortfolioAnalysis(portfolioId, userId, interval)

Get portfolio analysis

### Example
```dart
import 'package:am_portfolio_client/api.dart';

final api = AmPortfolioClient().getPortfolioApi();
final String portfolioId = portfolioId_example; // String | 
final String userId = userId_example; // String | 
final TimeInterval interval = ; // TimeInterval | 

try {
    final response = api.getPortfolioAnalysis(portfolioId, userId, interval);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PortfolioApi->getPortfolioAnalysis: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **portfolioId** | **String**|  | 
 **userId** | **String**|  | 
 **interval** | [**TimeInterval**](.md)|  | [optional] 

### Return type

[**PortfolioAnalysis**](PortfolioAnalysis.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPortfolioById**
> PortfolioModelV1 getPortfolioById(portfolioId)

Get portfolio by ID

### Example
```dart
import 'package:am_portfolio_client/api.dart';

final api = AmPortfolioClient().getPortfolioApi();
final String portfolioId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final response = api.getPortfolioById(portfolioId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PortfolioApi->getPortfolioById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **portfolioId** | **String**|  | 

### Return type

[**PortfolioModelV1**](PortfolioModelV1.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPortfolios**
> BuiltList<PortfolioModelV1> getPortfolios(userId)

Get all portfolios for a user

### Example
```dart
import 'package:am_portfolio_client/api.dart';

final api = AmPortfolioClient().getPortfolioApi();
final String userId = userId_example; // String | 

try {
    final response = api.getPortfolios(userId);
    print(response);
} on DioException catch (e) {
    print('Exception when calling PortfolioApi->getPortfolios: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userId** | **String**|  | 

### Return type

[**BuiltList&lt;PortfolioModelV1&gt;**](PortfolioModelV1.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

