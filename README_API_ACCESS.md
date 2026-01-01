# Portfolio API Access Guide

This document outlines how to connect to the Portfolio Service endpoints across different environments.

## 1. Direct Local Access (Java/Maven)
When running the application locally using `mvn spring-boot:run` or your IDE.

*   **Base URL**: `http://localhost:8075`
*   **Example Endpoint**: `http://localhost:8075/api/v1/portfolios`
*   **Swagger UI**: `http://localhost:8075/swagger-ui/index.html`

## 2. Docker Local Access
When running the application via Docker Compose (`am-portfolio-service` container).

*   **Base URL**: `http://localhost:8072` (Host port 8072 maps to container port 8075)
*   **Example Endpoint**: `http://localhost:8072/api/v1/portfolios`
*   **Swagger UI**: `http://localhost:8072/swagger-ui/index.html`

## 3. Gateway Access (Local Traefik)
When accessing via the local API Gateway (Traefik). This routes traffic through the configured paths in `am-infra`.

*   **Base URL**: `http://localhost:8000`
*   **Path Prefix**: `/api/portfolio`
*   **Routing Logic**: The gateway strips `/api/portfolio` and forwards the rest to the backend.
    *   Gateway Request: `/api/portfolio/api/v1/portfolios`
    *   Backend Receives: `/api/v1/portfolios`
*   **Example Endpoint**: `http://localhost:8000/api/portfolio/api/v1/portfolios`

## 4. Live Access (Production)
When accessing the deployed production environment.

*   **Base URL**: `https://am.munish.org`
*   **Path Prefix**: `/api/portfolio`
*   **Example Endpoint**: `https://am.munish.org/api/portfolio/api/v1/portfolios`

---

### Authentication
All protected endpoints require a Bearer Token (JWT).
*   **Header**: `Authorization: Bearer <your_token>`

### Analytics Endpoints
The analytics controller is mapped to `/api/v1/analytics/portfolio`.

*   **Direct/Docker**: `/api/v1/analytics/portfolio/{portfolioId}/advanced`
*   **Gateway/Live**: `/api/portfolio/api/v1/analytics/portfolio/{portfolioId}/advanced`
