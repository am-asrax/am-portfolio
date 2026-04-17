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
