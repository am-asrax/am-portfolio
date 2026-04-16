from typing import Dict, Any, List
from datetime import datetime
from ..models.fund import FundData
from ..models.portfolio import PortfolioSummary
from ..models.nav import NavHistory
from ..models.metrics import KeyMetrics
from ..models.value_objects import StockAllocation, IndustryAllocation, CashEquivalents, PlanType

class FundDataBuilder:
    """
    Builder class to construct FundData objects from raw JSON data.
    """
    
    @classmethod
    def from_json(cls, json_data: Dict[str, Any]) -> FundData:
        """
        Convert JSON data into a FundData domain model.
        
        Args:
            json_data: Dictionary containing fund data in the expected JSON format
            
        Returns:
            FundData: Populated FundData domain model
        """
        # Extract stock allocations
        stock_allocations = [
            StockAllocation(
                isin=stock["isin"],
                company=stock["security_name"],
                industry=stock["industry"],
                quantity=stock["quantity"],
                market_value_lakhs=stock["market_value_lakhs"],
                nav_percentage=stock["nav_percentage"]
            )
            for stock in json_data.get("stock_allocations", [])
        ]
        
        # Extract portfolio summary
        portfolio_summary = cls._build_portfolio_summary(json_data.get("portfolio_summary", {}))
        
        # Extract NAV history
        nav_history = cls._build_nav_history(json_data.get("nav_history", {}))
        
        # Extract key metrics
        key_metrics = cls._build_key_metrics(json_data.get("key_metrics", {}))
        
        # Create and return FundData instance
        return FundData(
            fund_name=json_data.get("fund_metadata", {}).get("fund_name", ""),
            portfolio_date=cls._format_date(json_data.get("fund_metadata", {}).get("portfolio_date")),
            stock_allocations=stock_allocations,
            portfolio_summary=portfolio_summary,
            nav_history=nav_history,
            key_metrics=key_metrics
        )
    
    @staticmethod
    def _build_portfolio_summary(portfolio_data: Dict[str, Any]) -> PortfolioSummary:
        """Build PortfolioSummary from raw portfolio data."""
        cash_equivalents = portfolio_data.get("cash_equivalents", {})
        
        return PortfolioSummary(
            total_value_lakhs=portfolio_data.get("total_value_lakhs", 0),
            cash_equivalents=CashEquivalents(
                treps=cash_equivalents.get("treps", 0),
                net_current_assets=cash_equivalents.get("net_current_assets", 0)
            ),
            industry_allocations=[
                IndustryAllocation(
                    industry=ia["industry"],
                    percentage=ia["percentage"]
                )
                for ia in portfolio_data.get("industry_allocations", [])
            ]
        )
    
    @staticmethod
    def _build_nav_history(nav_data: Dict[str, Any]) -> Dict[str, Dict[PlanType, float]]:
        """Convert NAV history data to the expected format."""
        nav_history = {}
        
        for date_str, nav_values in nav_data.items():
            nav_history[date_str] = {
                PlanType.IDCW_PLAN: nav_values.get("IDCW_Plan", 0),
                PlanType.IDCW_DIRECT: nav_values.get("IDCW_Option_Direct_Plan", 0),
                PlanType.GROWTH_PLAN: nav_values.get("Growth_Plan", 0),
                PlanType.GROWTH_DIRECT: nav_values.get("Growth_Option_Direct_Plan", 0)
            }
        
        return nav_history
    
    @staticmethod
    def _build_key_metrics(metrics_data: Dict[str, Any]) -> KeyMetrics:
        """Build KeyMetrics from raw metrics data."""
        return KeyMetrics(
            portfolio_turnover_ratio=metrics_data.get("portfolio_turnover_ratio", 0),
            risk_level=metrics_data.get("risk_level", ""),
            default_exposures=metrics_data.get("default_exposures", 0),
            derivative_exposures=metrics_data.get("derivative_exposures", 0)
        )
    
    @staticmethod
    def _format_date(date_str: str) -> str:
        """Convert date string to DD-MMM-YYYY format."""
        try:
            date_obj = datetime.strptime(date_str, "%Y-%m-%d")
            return date_obj.strftime("%d-%b-%Y")
        except (ValueError, TypeError):
            return ""
