# am_portfolio_client.PortfolioApi

All URIs are relative to *http://localhost:8060*

Method | HTTP request | Description
------------- | ------------- | -------------
[**get_portfolio_analysis**](PortfolioApi.md#get_portfolio_analysis) | **GET** /api/v1/portfolios/{portfolioId}/analysis | Get portfolio analysis
[**get_portfolio_by_id**](PortfolioApi.md#get_portfolio_by_id) | **GET** /api/v1/portfolios/{portfolioId} | Get portfolio by ID
[**get_portfolios**](PortfolioApi.md#get_portfolios) | **GET** /api/v1/portfolios | Get all portfolios for a user


# **get_portfolio_analysis**
> PortfolioAnalysis get_portfolio_analysis(portfolio_id, user_id, interval=interval)

Get portfolio analysis

### Example


```python
import am_portfolio_client
from am_portfolio_client.models.portfolio_analysis import PortfolioAnalysis
from am_portfolio_client.models.time_interval import TimeInterval
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
    api_instance = am_portfolio_client.PortfolioApi(api_client)
    portfolio_id = 'portfolio_id_example' # str | 
    user_id = 'user_id_example' # str | 
    interval = am_portfolio_client.TimeInterval() # TimeInterval |  (optional)

    try:
        # Get portfolio analysis
        api_response = api_instance.get_portfolio_analysis(portfolio_id, user_id, interval=interval)
        print("The response of PortfolioApi->get_portfolio_analysis:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling PortfolioApi->get_portfolio_analysis: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **portfolio_id** | **str**|  | 
 **user_id** | **str**|  | 
 **interval** | [**TimeInterval**](.md)|  | [optional] 

### Return type

[**PortfolioAnalysis**](PortfolioAnalysis.md)

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

# **get_portfolio_by_id**
> PortfolioModelV1 get_portfolio_by_id(portfolio_id)

Get portfolio by ID

### Example


```python
import am_portfolio_client
from am_portfolio_client.models.portfolio_model_v1 import PortfolioModelV1
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
    api_instance = am_portfolio_client.PortfolioApi(api_client)
    portfolio_id = UUID('38400000-8cf0-11bd-b23e-10b96e4ef00d') # UUID | 

    try:
        # Get portfolio by ID
        api_response = api_instance.get_portfolio_by_id(portfolio_id)
        print("The response of PortfolioApi->get_portfolio_by_id:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling PortfolioApi->get_portfolio_by_id: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **portfolio_id** | **UUID**|  | 

### Return type

[**PortfolioModelV1**](PortfolioModelV1.md)

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

# **get_portfolios**
> List[PortfolioModelV1] get_portfolios(user_id)

Get all portfolios for a user

### Example


```python
import am_portfolio_client
from am_portfolio_client.models.portfolio_model_v1 import PortfolioModelV1
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
    api_instance = am_portfolio_client.PortfolioApi(api_client)
    user_id = 'user_id_example' # str | 

    try:
        # Get all portfolios for a user
        api_response = api_instance.get_portfolios(user_id)
        print("The response of PortfolioApi->get_portfolios:\n")
        pprint(api_response)
    except Exception as e:
        print("Exception when calling PortfolioApi->get_portfolios: %s\n" % e)
```



### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **user_id** | **str**|  | 

### Return type

[**List[PortfolioModelV1]**](PortfolioModelV1.md)

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

