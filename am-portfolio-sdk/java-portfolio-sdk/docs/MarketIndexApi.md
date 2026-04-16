# MarketIndexApi

All URIs are relative to *http://localhost:8060*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getAllMarketIndices**](MarketIndexApi.md#getAllMarketIndices) | **GET** /api/v1/market-index/all | Get all market indices |
| [**getAllMarketIndicesWithHttpInfo**](MarketIndexApi.md#getAllMarketIndicesWithHttpInfo) | **GET** /api/v1/market-index/all | Get all market indices |



## getAllMarketIndices

> List<IndexIndices> getAllMarketIndices(interval, type)

Get all market indices

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.MarketIndexApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        MarketIndexApi apiInstance = new MarketIndexApi(defaultClient);
        String interval = "interval_example"; // String | 
        String type = "type_example"; // String | 
        try {
            List<IndexIndices> result = apiInstance.getAllMarketIndices(interval, type);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling MarketIndexApi#getAllMarketIndices");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Reason: " + e.getResponseBody());
            System.err.println("Response headers: " + e.getResponseHeaders());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **interval** | **String**|  | [optional] |
| **type** | **String**|  | [optional] |

### Return type

[**List&lt;IndexIndices&gt;**](IndexIndices.md)


### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |

## getAllMarketIndicesWithHttpInfo

> ApiResponse<List<IndexIndices>> getAllMarketIndices getAllMarketIndicesWithHttpInfo(interval, type)

Get all market indices

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.ApiResponse;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.MarketIndexApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        MarketIndexApi apiInstance = new MarketIndexApi(defaultClient);
        String interval = "interval_example"; // String | 
        String type = "type_example"; // String | 
        try {
            ApiResponse<List<IndexIndices>> response = apiInstance.getAllMarketIndicesWithHttpInfo(interval, type);
            System.out.println("Status code: " + response.getStatusCode());
            System.out.println("Response headers: " + response.getHeaders());
            System.out.println("Response body: " + response.getData());
        } catch (ApiException e) {
            System.err.println("Exception when calling MarketIndexApi#getAllMarketIndices");
            System.err.println("Status code: " + e.getCode());
            System.err.println("Response headers: " + e.getResponseHeaders());
            System.err.println("Reason: " + e.getResponseBody());
            e.printStackTrace();
        }
    }
}
```

### Parameters


| Name | Type | Description  | Notes |
|------------- | ------------- | ------------- | -------------|
| **interval** | **String**|  | [optional] |
| **type** | **String**|  | [optional] |

### Return type

ApiResponse<[**List&lt;IndexIndices&gt;**](IndexIndices.md)>


### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |

