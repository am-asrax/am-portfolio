# am_portfolio_client.MarketIndexApi

All URIs are relative to *http://localhost:8060*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_all_market_indices**](MarketIndexApi.md#get_all_market_indices) | **GET** /api/v1/market-index/all | Get all market indices


# **get_all_market_indices**
> List[IndexIndices] get_all_market_indices(interval=interval, type=type)

Get all market indices

### Example


```python
import am_portfolio_client
from am_portfolio_client.models.index_indices import IndexIndices
from am_portfolio_client.rest import ApiException
from pprint import pprint

# Defining the host is optional and defaults to http://localhost:8060
# See configuration.py for a list of all supported configuration parameters.
configuration = am_portfolio_client.Configuration(
    host = "http://localhost:8060"
)


# Enter a context with an instance of the API client
with am_portfolio_client.ApiClient(configuration) as api_client:
    # Create an instance of the API class
    api_instance = am_portfolio_client.MarketIndexApi(api_client)
    interval = 'interval_example' # str |  (optional)
    type = 'type_example' # str |  (optional)

    try:
        # Get all market indices
        api_response = api_instance.get_all_market_indices(interval=interval, type=type)
        print("The response of MarketIndexApi->get_all_market_indices:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling MarketIndexApi->get_all_market_indices: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **interval** | **str**|  | [optional] 
 **type** | **str**|  | [optional] 

### Return type

[**List[IndexIndices]**](IndexIndices.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

### HTTP response details

| Status code | Description | Response headers |
|-------------|-------------|------------------|
**200** | OK |  -  |

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

