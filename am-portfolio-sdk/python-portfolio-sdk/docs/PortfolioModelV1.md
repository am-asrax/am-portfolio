# PortfolioModelV1


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **UUID** |  | [optional] 
**user_id** | **str** |  | [optional] 
**name** | **str** |  | [optional] 
**description** | **str** |  | [optional] 
**created_at** | **datetime** |  | [optional] 

## Example

```python
from am_portfolio_client.models.portfolio_model_v1 import PortfolioModelV1

# TODO update the JSON string below
json = "{}"
# create an instance of PortfolioModelV1 from a JSON string
portfolio_model_v1_instance = PortfolioModelV1.from_json(json)
# print the JSON string representation of the object
print(PortfolioModelV1.to_json())

# convert the object into a dict
portfolio_model_v1_dict = portfolio_model_v1_instance.to_dict()
# create an instance of PortfolioModelV1 from a dict
portfolio_model_v1_from_dict = PortfolioModelV1.from_dict(portfolio_model_v1_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


