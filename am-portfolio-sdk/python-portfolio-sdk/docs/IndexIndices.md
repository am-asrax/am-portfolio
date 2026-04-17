# IndexIndices


## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**key** | **str** |  | [optional] 
**index** | **str** |  | [optional] 
**index_symbol** | **str** |  | [optional] 
**timestamp** | **datetime** |  | [optional] 

## Example

```python
from am_portfolio_client.models.index_indices import IndexIndices

# TODO update the JSON string below
json = "{}"
# create an instance of IndexIndices from a JSON string
index_indices_instance = IndexIndices.from_json(json)
# print the JSON string representation of the object
print(IndexIndices.to_json())

# convert the object into a dict
index_indices_dict = index_indices_instance.to_dict()
# create an instance of IndexIndices from a dict
index_indices_from_dict = IndexIndices.from_dict(index_indices_dict)
```
[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


