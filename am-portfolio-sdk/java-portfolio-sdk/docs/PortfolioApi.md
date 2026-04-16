# PortfolioApi

All URIs are relative to *http://localhost:8060*

| Method | HTTP request | Description |
|------------- | ------------- | -------------|
| [**getPortfolioAnalysis**](PortfolioApi.md#getPortfolioAnalysis) | **GET** /api/v1/portfolios/{portfolioId}/analysis | Get portfolio analysis |
| [**getPortfolioAnalysisWithHttpInfo**](PortfolioApi.md#getPortfolioAnalysisWithHttpInfo) | **GET** /api/v1/portfolios/{portfolioId}/analysis | Get portfolio analysis |
| [**getPortfolioById**](PortfolioApi.md#getPortfolioById) | **GET** /api/v1/portfolios/{portfolioId} | Get portfolio by ID |
| [**getPortfolioByIdWithHttpInfo**](PortfolioApi.md#getPortfolioByIdWithHttpInfo) | **GET** /api/v1/portfolios/{portfolioId} | Get portfolio by ID |
| [**getPortfolios**](PortfolioApi.md#getPortfolios) | **GET** /api/v1/portfolios | Get all portfolios for a user |
| [**getPortfoliosWithHttpInfo**](PortfolioApi.md#getPortfoliosWithHttpInfo) | **GET** /api/v1/portfolios | Get all portfolios for a user |



## getPortfolioAnalysis

> PortfolioAnalysis getPortfolioAnalysis(portfolioId, userId, interval)

Get portfolio analysis

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.PortfolioApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        PortfolioApi apiInstance = new PortfolioApi(defaultClient);
        String portfolioId = "portfolioId_example"; // String | 
        String userId = "userId_example"; // String | 
        TimeInterval interval = TimeInterval.fromValue("1D"); // TimeInterval | 
        try {
            PortfolioAnalysis result = apiInstance.getPortfolioAnalysis(portfolioId, userId, interval);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling PortfolioApi#getPortfolioAnalysis");
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
| **portfolioId** | **String**|  | |
| **userId** | **String**|  | |
| **interval** | [**TimeInterval**](.md)|  | [optional] [enum: 1D, 1W, 1M, 1Y, ALL] |

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
| **200** | OK |  -  |

## getPortfolioAnalysisWithHttpInfo

> ApiResponse<PortfolioAnalysis> getPortfolioAnalysis getPortfolioAnalysisWithHttpInfo(portfolioId, userId, interval)

Get portfolio analysis

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.ApiResponse;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.PortfolioApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        PortfolioApi apiInstance = new PortfolioApi(defaultClient);
        String portfolioId = "portfolioId_example"; // String | 
        String userId = "userId_example"; // String | 
        TimeInterval interval = TimeInterval.fromValue("1D"); // TimeInterval | 
        try {
            ApiResponse<PortfolioAnalysis> response = apiInstance.getPortfolioAnalysisWithHttpInfo(portfolioId, userId, interval);
            System.out.println("Status code: " + response.getStatusCode());
            System.out.println("Response headers: " + response.getHeaders());
            System.out.println("Response body: " + response.getData());
        } catch (ApiException e) {
            System.err.println("Exception when calling PortfolioApi#getPortfolioAnalysis");
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
| **portfolioId** | **String**|  | |
| **userId** | **String**|  | |
| **interval** | [**TimeInterval**](.md)|  | [optional] [enum: 1D, 1W, 1M, 1Y, ALL] |

### Return type

ApiResponse<[**PortfolioAnalysis**](PortfolioAnalysis.md)>


### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |


## getPortfolioById

> PortfolioModelV1 getPortfolioById(portfolioId)

Get portfolio by ID

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.PortfolioApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        PortfolioApi apiInstance = new PortfolioApi(defaultClient);
        UUID portfolioId = UUID.randomUUID(); // UUID | 
        try {
            PortfolioModelV1 result = apiInstance.getPortfolioById(portfolioId);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling PortfolioApi#getPortfolioById");
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
| **portfolioId** | **UUID**|  | |

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
| **200** | OK |  -  |

## getPortfolioByIdWithHttpInfo

> ApiResponse<PortfolioModelV1> getPortfolioById getPortfolioByIdWithHttpInfo(portfolioId)

Get portfolio by ID

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.ApiResponse;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.PortfolioApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        PortfolioApi apiInstance = new PortfolioApi(defaultClient);
        UUID portfolioId = UUID.randomUUID(); // UUID | 
        try {
            ApiResponse<PortfolioModelV1> response = apiInstance.getPortfolioByIdWithHttpInfo(portfolioId);
            System.out.println("Status code: " + response.getStatusCode());
            System.out.println("Response headers: " + response.getHeaders());
            System.out.println("Response body: " + response.getData());
        } catch (ApiException e) {
            System.err.println("Exception when calling PortfolioApi#getPortfolioById");
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
| **portfolioId** | **UUID**|  | |

### Return type

ApiResponse<[**PortfolioModelV1**](PortfolioModelV1.md)>


### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |


## getPortfolios

> List<PortfolioModelV1> getPortfolios(userId)

Get all portfolios for a user

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.PortfolioApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        PortfolioApi apiInstance = new PortfolioApi(defaultClient);
        String userId = "userId_example"; // String | 
        try {
            List<PortfolioModelV1> result = apiInstance.getPortfolios(userId);
            System.out.println(result);
        } catch (ApiException e) {
            System.err.println("Exception when calling PortfolioApi#getPortfolios");
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
| **userId** | **String**|  | |

### Return type

[**List&lt;PortfolioModelV1&gt;**](PortfolioModelV1.md)


### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |

## getPortfoliosWithHttpInfo

> ApiResponse<List<PortfolioModelV1>> getPortfolios getPortfoliosWithHttpInfo(userId)

Get all portfolios for a user

### Example

```java
// Import classes:
import com.am.portfolio.client.portfolio.invoker.ApiClient;
import com.am.portfolio.client.portfolio.invoker.ApiException;
import com.am.portfolio.client.portfolio.invoker.ApiResponse;
import com.am.portfolio.client.portfolio.invoker.Configuration;
import com.am.portfolio.client.portfolio.invoker.models.*;
import com.am.portfolio.client.portfolio.api.PortfolioApi;

public class Example {
    public static void main(String[] args) {
        ApiClient defaultClient = Configuration.getDefaultApiClient();
        defaultClient.setBasePath("http://localhost:8060");

        PortfolioApi apiInstance = new PortfolioApi(defaultClient);
        String userId = "userId_example"; // String | 
        try {
            ApiResponse<List<PortfolioModelV1>> response = apiInstance.getPortfoliosWithHttpInfo(userId);
            System.out.println("Status code: " + response.getStatusCode());
            System.out.println("Response headers: " + response.getHeaders());
            System.out.println("Response body: " + response.getData());
        } catch (ApiException e) {
            System.err.println("Exception when calling PortfolioApi#getPortfolios");
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
| **userId** | **String**|  | |

### Return type

ApiResponse<[**List&lt;PortfolioModelV1&gt;**](PortfolioModelV1.md)>


### Authorization

No authorization required

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json

### HTTP response details
| Status code | Description | Response headers |
|-------------|-------------|------------------|
| **200** | OK |  -  |

