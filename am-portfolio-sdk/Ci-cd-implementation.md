# AM Portfolio SDK - CI/CD & Modular Generation Strategy

This document outlines the architecture for generating and publishing the Portfolio SDKs (Java, Python, Flutter) to maintain consistency with the `am-market` ecosystem.

## 1. Modular Generator Architecture

The SDK generation is decoupled into an orchestration layer and specific language modules.

- **Orchestrator**: `generate_multi_api_sdks.ps1`
- **Logic Modules**: Located in `scripts/generator/`
    - `Core.ps1`: Universal OpenAPI generator wrappers.
    - `Java.ps1`: Custom Maven/POM logic for GitHub Packages.
    - `Python.ps1`: Python package and dependency configuration.
    - `Flutter.ps1`: Dart/Pubspec specific configurations.

### Generation Workflow
1. **Spec Sync**: The `portfolio-openapi.json` is maintained as the source of truth (synthesized from Portfolio APIs).
2. **Invoke**: Run `.\generate_multi_api_sdks.ps1` to trigger parallel generation for all supported platforms.
3. **Robust Configuration**: To avoid shell argument splitting bugs (e.g., in parameter descriptions), the `Invoke-OpenApiGen` function generates a temporary `generator-config.json` and passes it via the `-c` flag.
4. **Customization**: Post-generation scripts (in `Java.ps1`) inject custom `pom.xml` files to ensure proper registry mapping.

## 2. GitHub Packages Integration

All Java artifacts are published to the **GitHub Package Registry** for the `AM-Portfolio/am-portfolio` repository.

### Distribution Management
```xml
<distributionManagement>
    <repository>
        <id>github-investment</id>
        <name>GitHub Packages</name>
        <url>https://maven.pkg.github.com/AM-Portfolio/am-portfolio</url>
    </repository>
</distributionManagement>
```

## 3. CI/CD Pipeline (`am-sdk-publish.yml`)

The automated pipeline is configured to:
1. **Detect Changes**: Monitors only the `am-portfolio-sdk/` directory.
2. **Modular Detection**: Identifies which specific SDK (Java, Python, or Flutter) was modified.
3. **Centralized Publishing**: Utilizes the `AM-Portfolio/am-pipelines` reusable workflow for standardized publishing logic.

### Trigger Logic
```yaml
on:
  push:
    paths:
      - 'am-portfolio-sdk/**'
```

## 4. Maintenance & Local Development

To generate SDKs locally:
```powershell
# In am-portfolio/am-portfolio-sdk directory
.\generate_multi_api_sdks.ps1
```

To verify the Java SDK:
```bash
cd java-portfolio-sdk
mvn compile
```

> [!IMPORTANT]
> **Authentication**: Ensure `GITHUB_PACKAGES_USERNAME` and `GITHUB_PACKAGES_TOKEN` are set in your environment variables for local Maven or Pub operations that interface with private packages.

## 5. Troubleshooting: Build Alignments & Fixes

During the initial deployment of the SDK generation triggers, a build failure occasionally occurs in the main application pipeline.

**Here is exactly what happened and how to fix it:**

### The Root Cause of the Git Trigger Failure
There wasn't an issue with the "Git Trigger" itself; it functioned exactly as intended. Because your previous push changed files in both the SDK directory `am-portfolio-sdk/` **and** the main application (`portfolio-redis/pom.xml`, `portfolio-app/application.yml`), GitHub Actions concurrently triggered **two separate workflows**:
1.  **AM SDK Publish (#1)**: This detected the SDK file changes, mapped everything smoothly using the newly injected script configurations, and **Succeeded (45s)**.
2.  **AM Portfolio Publish (#2)**: This detected the changes to the central application but ran into a **Compilation Error** and **Failed (1m 29s)**.

### What Was Broken in the Application?
During the SDK iterations, elements of the main application's configuration were broken:
1.  **Dependency Break (`portfolio-redis`)**: The version variable for `am-common-investment-model` was accidentally bumped to `${am.common.version}` (1.2.9-Snapshot) instead of the actual valid version `${am.investment.version}` (1.6.22-Snapshot). Maven threw a 401 Unauthorized warning while trying to fetch the non-existent version logic.
2.  **Duplicated YAML Block (`portfolio-app/application.yml`)**: A secondary duplicate `app:` block was placed at the bottom harboring the `jwt: secret: "dummy..."`, which can confuse Spring Boot into silently invalidating key parts of your hierarchy.
3.  **Port Misalignment (`helm/values.*.yaml`)**: While we successfully shifted the `server.port` to **8060** inside the app (adhering to global standards), the `ClusterIP` routing and `Prometheus` scraping ports within your Preprod and Prod Helm charts were still rigidly pinned to `8080`.

### The Resolution (Fixed & Pushed)
Applied the following fixes step-by-step:
* Edited `portfolio-redis/pom.xml`: Restored the `<version>${am.investment.version}</version>`.
* Edited `portfolio-app/application.yml`: Eliminated the duplicate `app:` tree and properly nested the local `jwt:` stub cleanly inside the main loop.
* Edited `helm/values.preprod.yaml`: Updated `service.port` and `prometheus.port` to `8060`.
* Edited `helm/values.prod.yaml`: Updated `service.port` and `prometheus.port` to `8060`.
* Ran command: `mvn clean compile` locally across all 9 components producing `BUILD SUCCESS`.
* Ran command: `git add . ; git commit -m "fix(pipeline): resolve dependency mismatch and port configuration issues" ; git push origin feature/ci-cd-portfolio`
