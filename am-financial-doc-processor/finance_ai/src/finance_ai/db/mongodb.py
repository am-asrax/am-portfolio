from pymongo import MongoClient
from ..config.config import settings

class MongoDB:
    def __init__(self):
        self.client = MongoClient(settings.MONGO_URI)
        self.db = self.client[settings.DATABASE_NAME]
        self.collection = self.db[settings.COLLECTION_NAME]

    def insert_fund_data(self, data: dict) -> str:
        result = self.collection.insert_one(data)
        return str(result.inserted_id)

    def get_fund_data(self, query: dict) -> list:
        return list(self.collection.find(query))

    def close(self):
        self.client.close()
