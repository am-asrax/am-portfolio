# PortfolioAnalysis


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**portfolio_id** | **str** |  | [optional] 
**last_updated** | **datetime** |  | [optional] 
**current_interval** | [**TimeInterval**](TimeInterval.md) |  | [optional] 

## Example

```python
from am_portfolio_client.models.portfolio_analysis import PortfolioAnalysis

# TODO update the JSON string below
json = "{}"
# create an instance of PortfolioAnalysis from a JSON string
portfolio_analysis_instance = PortfolioAnalysis.from_json(json)
# print the JSON string representation of the object
print(PortfolioAnalysis.to_json())

# convert the object into a dict
portfolio_analysis_dict = portfolio_analysis_instance.to_dict()
# create an instance of PortfolioAnalysis from a dict
portfolio_analysis_from_dict = PortfolioAnalysis.from_dict(portfolio_analysis_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


