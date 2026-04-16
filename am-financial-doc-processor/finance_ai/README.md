# Finance AI Document Processor

This application processes financial fund data from Excel files using AI to extract meaningful insights and stores the data in MongoDB.

## Project Structure

```
finance_ai/
├── src/
│   └── finance_ai/
│       ├── api/            # FastAPI endpoints
│       ├── models/         # Pydantic models
│       ├── services/       # Business logic
│       ├── db/            # Database operations
│       ├── ai_integration/ # AI processing logic
│       └── config/        # Configuration
├── tests/                 # Unit tests
├── docs/                  # Documentation
└── scripts/              # Utility scripts
```

## Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Create a `.env` file in the root directory with:
```
MONGO_URI=mongodb://localhost:27017
OPENAI_API_KEY=your_openai_api_key
```

## Running the Application

1. Start MongoDB (ensure it's installed and running)

2. Start the FastAPI server:
```bash
uvicorn src.finance_ai.api.main:app --reload
```

## API Endpoints

- `POST /api/fund/upload` - Upload and process an Excel file
- `GET /api/fund/{fund_name}` - Get data for a specific fund
- `GET /api/fund` - Get data for all funds

## Features

- Excel file processing
- AI-powered data extraction using LangChain and OpenAI
- MongoDB storage
- RESTful API endpoints
- Modular architecture
