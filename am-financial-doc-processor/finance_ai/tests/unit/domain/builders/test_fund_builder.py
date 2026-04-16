import json
import os
import sys
import pytest
from datetime import datetime

# Add the project root to the Python path
project_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../../'))
print(f"Adding to Python path: {project_root}")
sys.path.insert(0, project_root)

from finance_ai.domain.builders.fund_builder import FundDataBuilder
from finance_ai.domain.models.fund import FundData
from finance_ai.domain.models.value_objects import StockAllocation, IndustryAllocation, CashEquivalents, PlanType

def load_test_data():
    """Load test data from the JSON file."""
    test_file = os.path.join(
        os.path.dirname(__file__), 
        "../../../../src/finance_ai/testdata/hdfcdefence.json"
    )
    print(f"Loading test data from: {test_file}")
    try:
        with open(test_file, 'r') as f:
            data = json.load(f)
            print("Test data loaded successfully")
            return data
    except FileNotFoundError:
        print(f"Error: Test data file not found at {test_file}")
        raise
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON in test data file: {e}")
        raise

class TestFundDataBuilder:
    """Test cases for FundDataBuilder."""
    
    @pytest.fixture
    def test_data(self):
        return load_test_data()
    
    def test_from_json_creates_valid_fund_data(self, test_data):
        """Test that from_json creates a valid FundData object."""
        print("\nRunning test_from_json_creates_valid_fund_data")
        # Act
        print("Creating FundData from JSON...")
        fund_data = FundDataBuilder.from_json(test_data)
        
        # Assert
        print(f"Validating fund_data: {fund_data}")
        assert isinstance(fund_data, FundData)
        assert fund_data.fund_name == "HDFC Defence Fund"
        assert fund_data.portfolio_date == "30-Apr-2025"
        print("Test passed successfully!")
        
    def test_stock_allocations_are_correctly_mapped(self, test_data):
        """Test that stock allocations are correctly mapped."""
        # Act
        fund_data = FundDataBuilder.from_json(test_data)
        
        # Assert
        assert len(fund_data.stock_allocations) > 0
        first_stock = fund_data.stock_allocations[0]
        assert isinstance(first_stock, StockAllocation)
        assert first_stock.isin == "INE066F01020"
        assert first_stock.company == "Hindustan Aeronautics Limited"
        assert first_stock.industry == "Aerospace & Defense"
        
    def test_portfolio_summary_is_correctly_mapped(self, test_data):
        """Test that portfolio summary is correctly mapped."""
        # Act
        fund_data = FundDataBuilder.from_json(test_data)
        portfolio = fund_data.portfolio_summary
        
        # Assert
        assert isinstance(portfolio, type(fund_data).__annotations__["portfolio_summary"])
        assert portfolio.total_value_lakhs > 0
        assert isinstance(portfolio.cash_equivalents, CashEquivalents)
        assert len(portfolio.industry_allocations) > 0
        assert isinstance(portfolio.industry_allocations[0], IndustryAllocation)
        
    def test_nav_history_is_correctly_mapped(self, test_data):
        """Test that NAV history is correctly mapped."""
        # Arrange
        test_data["nav_history"] = {
            "30-Apr-2025": {
                "IDCW_Plan": 20.955,
                "IDCW_Option_Direct_Plan": 21.432,
                "Growth_Plan": 20.955,
                "Growth_Option_Direct_Plan": 21.432
            }
        }
        
        # Act
        fund_data = FundDataBuilder.from_json(test_data)
        
        # Assert
        assert "30-Apr-2025" in fund_data.nav_history
        nav_values = fund_data.nav_history["30-Apr-2025"]
        assert nav_values[PlanType.IDCW_PLAN] == 20.955
        assert nav_values[PlanType.IDCW_DIRECT] == 21.432
        assert nav_values[PlanType.GROWTH_PLAN] == 20.955
        assert nav_values[PlanType.GROWTH_DIRECT] == 21.432
    
    def test_key_metrics_are_correctly_mapped(self, test_data):
        """Test that key metrics are correctly mapped."""
        # Arrange
        test_data["key_metrics"] = {
            "portfolio_turnover_ratio": 9.27,
            "risk_level": "Moderate",
            "default_exposures": 0.0,
            "derivative_exposures": 0.0
        }
        
        # Act
        fund_data = FundDataBuilder.from_json(test_data)
        
        # Assert
        metrics = fund_data.key_metrics
        assert metrics.portfolio_turnover_ratio == 9.27
        assert metrics.risk_level == "Moderate"
        assert metrics.default_exposures == 0.0
        assert metrics.derivative_exposures == 0.0
    
    def test_empty_data_handling(self):
        """Test that the builder handles empty data gracefully."""
        # Act
        fund_data = FundDataBuilder.from_json({})
        
        # Assert
        assert fund_data.fund_name == ""
        assert fund_data.portfolio_date == ""
        assert fund_data.stock_allocations == []
        assert fund_data.portfolio_summary is not None
        assert fund_data.nav_history == {}
        assert fund_data.key_metrics is not None

if __name__ == '__main__':
    print("Running tests directly...")
    test_instance = TestFundDataBuilder()
    test_data = load_test_data()
    
    # Run the tests
    test_instance.test_from_json_creates_valid_fund_data(test_data)
    test_instance.test_stock_allocations_are_correctly_mapped(test_data)
    test_instance.test_portfolio_summary_is_correctly_mapped(test_data)
    test_instance.test_nav_history_is_correctly_mapped(test_data)
    test_instance.test_key_metrics_are_correctly_mapped(test_data)
    test_instance.test_empty_data_handling()
    
    print("\nAll tests completed!")
