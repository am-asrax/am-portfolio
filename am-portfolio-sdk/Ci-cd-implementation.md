# AM Portfolio — CI/CD & SDK Publishing Implementation

> **Date**: 2026-04-16  
> **Branch**: `feature/ci-cd-portfolio`  
> **Reference Blueprint**: [am-market workflows](https://github.com/AM-Portfolio/am-market/tree/main/.github/workflows)

---

## 1. What Existed Before (Previous State)

Before this implementation, `am-portfolio` had:

```
am-portfolio/
├── .github/workflows/
│   └── (nothing or old workflows)    ← No centralized CI/CD
├── portfolio-api/
├── portfolio-service/
├── portfolio-app/
├── portfolio-analytics/
├── portfolio-market-data/
├── portfolio-model/
├── portfolio-kafka/
├── portfolio-redis/
├── helm/
├── Dockerfile
├── docker-compose.yml
└── pom.xml
```

### Problems with the previous state:
- ❌ **No automated SDK publishing** — Other services (like `am-investment-ui`, Flutter apps) had no way to consume portfolio APIs as a library
- ❌ **No centralized deployment pipeline** — Deployment was manual or used ad-hoc workflows
- ❌ **No OpenAPI spec extraction** — No tooling to extract API definitions from the running service
- ❌ **Inconsistent with am-market** — `am-market` already had a mature SDK pipeline; `am-portfolio` was behind

---

## 2. What Was Changed (All New Files)

### 2.1 Workflow Files (`.github/workflows/`)

#### [NEW] `am-portfolio-publish.yml` — Application Deployment

**What it does**: Builds, containerizes, and deploys the portfolio Java application.

**Why it was added**: To replace manual deployments with automated CI/CD using the centralized `am-pipelines` repository, matching `am-market`'s `am-app-publish.yml`.

```yaml
# Triggers on changes to application code
on:
  push:
    branches: ["main", "develop", "test/**", "feature/**"]
    paths:
      - 'portfolio-service/**'
      - 'portfolio-api/**'
      - 'portfolio-app/**'
      - 'portfolio-analytics/**'
      - 'portfolio-market-data/**'
      - 'portfolio-model/**'
      - 'portfolio-kafka/**'
      - 'portfolio-redis/**'
      - 'helm/**'
      - 'pom.xml'

# Delegates to central pipeline
jobs:
  publish:
    uses: AM-Portfolio/am-pipelines/.github/workflows/central-build-publish.yml@main
    with:
      language: 'java'
      image_name: 'am-portfolio'
      deploy_prod: true
```

**Expected Output**: Every push to `main`/`develop`/`feature/**` that touches app code automatically builds a Docker image and deploys it.

---

#### [NEW] `am-sdk-publish.yml` — SDK Publishing

**What it does**: Detects which SDK folder changed and publishes only those SDKs to GitHub Packages.

**Why it was added**: This is the **core of the SDK publishing feature**. It mirrors `am-market`'s `am-sdk-publish.yml` exactly. Without this, generated SDKs would just sit in the repo with no way to distribute them.

**How it works**:
1. **Trigger**: Only fires on changes inside `am-portfolio-sdk/**`
2. **detect-changes job**: Runs `git diff` to check which SDK sub-folder was modified
3. **publish jobs**: For each changed SDK, calls `am-pipelines/publish-library.yml`

```yaml
# Detect changes
check() { echo "$CHANGED" | grep -q "^$1" && echo 'true' || echo 'false'; }
echo "java-portfolio=$(check 'am-portfolio-sdk/java-portfolio-sdk/')"
echo "python-portfolio=$(check 'am-portfolio-sdk/python-portfolio-sdk/')"
echo "flutter-portfolio=$(check 'am-portfolio-sdk/flutter-portfolio-sdk/')"

# Publish (per language)
uses: AM-Portfolio/am-pipelines/.github/workflows/publish-library.yml@main
with:
  language: 'java' | 'python' | 'flutter'
  working_directory: 'am-portfolio-sdk/<lang>-portfolio-sdk'
  sdk_name: '<lang>-portfolio-sdk'
```

**Comparison with am-market**:
| Aspect | am-market | am-portfolio |
|--------|-----------|-------------|
| SDK count | 6 (market+parser × 3 langs) | 3 (portfolio × 3 langs) |
| Trigger path | `am-market-sdk/**` | `am-portfolio-sdk/**` |
| Maven repo | `github.com/AM-Portfolio/am-market` | `github.com/AM-Portfolio/am-portfolio` |

**Expected Output**: When you push generated SDK code, GitHub Actions automatically publishes the changed SDKs to GitHub Packages. Only modified SDKs are republished (not all 3 every time).

---

### 2.2 SDK Generation Toolkit (`am-portfolio-sdk/`)

#### [NEW] `openapitools.json` — Generator Version Lock

**What it does**: Pins the OpenAPI Generator CLI to version `7.18.0`.

**Why**: Ensures every developer and CI run generates identical SDK code. Without this, different `npx` invocations might use different generator versions and produce incompatible code.

```json
{
  "$schema": "./node_modules/@openapitools/openapi-generator-cli/config.schema.json",
  "spaces": 2,
  "generator-cli": {
    "version": "7.18.0"
  }
}
```

**Expected Output**: `npx @openapitools/openapi-generator-cli` always uses v7.18.0.

---

#### [NEW] `.gitignore` — SDK-specific Git Ignores

**What it does**: Prevents temporary and build files from being committed.

**Why**: The generator creates temp config files (`gen-config-*.json`) and `node_modules/` which should never be in Git. Build artifacts (`target/`, `dist/`) also bloat the repo.

```gitignore
gen-config-*.json          # Temp configs created during generation
node_modules/              # npx downloads
java-portfolio-sdk/target/ # Maven build output
python-portfolio-sdk/dist/ # Python build output
flutter-portfolio-sdk/.dart_tool/  # Dart tooling cache
```

**Expected Output**: Clean commits containing only generated source code, not build artifacts.

---

#### [NEW] `generate_sdks.ps1` — Master Generation Script

**What it does**: The **single entry point** you run to generate all SDKs. It:
1. Checks if `portfolio-openapi.json` exists
2. Imports all generator modules (`Core.ps1`, `Java.ps1`, `Flutter.ps1`, `Python.ps1`)
3. Calls each language generator with portfolio-specific parameters

**Why**: Mirrors `am-market`'s `generate_multi_api_sdks.ps1`. Provides a simple one-command workflow.

**Key differences from am-market**:
| Parameter | am-market | am-portfolio |
|-----------|-----------|-------------|
| Spec file | `market-data-openapi.json` + `parser-openapi.json` | `portfolio-openapi.json` |
| Java artifactId | `am-market-client` / `am-parser-client` | `am-portfolio-client` |
| Flutter pubName | `am_market_client` / `am_parser_client` | `am_portfolio_client` |
| Python packageName | `am_market_client` / `am_parser_client` | `am_portfolio_client` |
| APIs | 2 (market + parser) | 1 (portfolio) |
| Flags | `-MarketOnly`, `-ParserOnly` | N/A (single API) |

**Usage**:
```powershell
.\generate_sdks.ps1              # All 3 SDKs
.\generate_sdks.ps1 -SkipPython  # Java + Flutter only
.\generate_sdks.ps1 -SkipFlutter -SkipPython  # Java only
```

**Expected Output**: Three folders created:
```
am-portfolio-sdk/
├── java-portfolio-sdk/      ← Maven project with pom.xml + src/
├── flutter-portfolio-sdk/   ← Dart package with pubspec.yaml + lib/
└── python-portfolio-sdk/    ← Python package with pyproject.toml + source/
```

---

#### [NEW] `scripts/extract_portfolio_openapi.ps1` — OpenAPI Spec Extractor

**What it does**: Automatically extracts the OpenAPI specification from the portfolio service:
1. Starts `portfolio-app` via `mvn spring-boot:run` on port **8060**
2. Waits up to 120 seconds for `/actuator/health` to return `200`
3. Calls `http://localhost:8060/v3/api-docs` to download the spec
4. Saves it as `portfolio-openapi.json`
5. Stops the service

**Why**: Without this, you'd have to manually start the service and `curl` the spec. This automates the entire process.

**Key difference from am-market**: Port `8020` → `8060` (per global port allocation rules).

**Expected Output**: `portfolio-openapi.json` file containing the full OpenAPI 3.0 specification of all portfolio REST endpoints.

---

#### [NEW] `scripts/generator/Core.ps1` — Shared Generation Engine

**What it does**: Contains `Invoke-OpenApiGen` — the function that ALL language generators call. It:
1. Cleans the output directory
2. Writes a temporary JSON config file
3. Runs `npx @openapitools/openapi-generator-cli generate`
4. Writes `ci-trigger.txt` with a timestamp (forces Git to detect a change)
5. Cleans up the temp config

**Why**: Avoids duplicating the same generator invocation logic in every language script. DRY principle.

**Unchanged from am-market**: This file is identical — it's language-agnostic.

**Expected Output**: Generated SDK source code in the specified output directory.

---

#### [NEW] `scripts/generator/Java.ps1` — Java SDK Generator

**What it does**: 
1. Calls `Core.ps1` with `generator = "java"` and `library = "native"` (uses Java 11 HttpClient)
2. After generation, replaces the auto-generated `pom.xml` with a custom one containing:
   - `groupId: com.am.portfolio`
   - Jackson dependencies (2.19.2)
   - `distributionManagement` → `https://maven.pkg.github.com/AM-Portfolio/am-portfolio`

**Key change from am-market**: Maven repo URL changed from `am-market` to `am-portfolio`.

**Expected Output**: `java-portfolio-sdk/` containing a complete Maven project ready to `mvn install`.

---

#### [NEW] `scripts/generator/Flutter.ps1` — Flutter/Dart SDK Generator

**What it does**:
1. Calls `Core.ps1` with `generator = "dart"`
2. Runs extensive **post-processing** to fix Dart 3 compatibility issues:
   - Fixes `.cast<Map>()` → `.cast<Map<String, Object>>()`
   - Removes illegal `dynamic.dart` model files
   - Adds `// ignore_for_file:` lint suppressions
   - Modernizes `pubspec.yaml` dependencies for Dart 3
   - Adds a smoke test file

**Why all the post-processing**: OpenAPI Generator's Dart output has known issues with Dart 3. These fixes were battle-tested in `am-market`.

**Unchanged from am-market**: All post-processing logic is identical.

**Expected Output**: `flutter-portfolio-sdk/` containing a valid Dart package that compiles with Dart 3.

---

#### [NEW] `scripts/generator/Python.ps1` — Python SDK Generator

**What it does**:
1. Calls `Core.ps1` with `generator = "python"`
2. Removes legacy files generated by OpenAPI Generator (`setup.py`, `tox.ini`, `.travis.yml`, etc.)
3. Writes a modern `pyproject.toml` with:
   - `setuptools >= 61.0` build system
   - `pydantic >= 2` dependency
   - AM Portfolio team metadata

**Why remove setup.py**: Modern Python uses `pyproject.toml`. The generator outputs legacy `setup.py` by default.

**Unchanged from am-market**: Identical logic, just different package names.

**Expected Output**: `python-portfolio-sdk/` containing a modern Python package installable with `pip install -e .`

---

## 3. End-to-End Flow

```
┌─────────────────────────────────────────────────────────────┐
│  LOCAL (Developer Machine)                                   │
│                                                              │
│  Step 1: Extract spec                                        │
│  .\scripts\extract_portfolio_openapi.ps1                     │
│     ↓ starts service on :8060                                │
│     ↓ downloads /v3/api-docs                                 │
│     ↓ saves portfolio-openapi.json                           │
│                                                              │
│  Step 2: Generate SDKs                                       │
│  .\generate_sdks.ps1                                         │
│     ↓ reads portfolio-openapi.json                           │
│     ↓ calls Java.ps1   → java-portfolio-sdk/                 │
│     ↓ calls Flutter.ps1 → flutter-portfolio-sdk/             │
│     ↓ calls Python.ps1  → python-portfolio-sdk/              │
│                                                              │
│  Step 3: Commit & Push                                       │
│  git add am-portfolio-sdk/ && git push                       │
└──────────────────────────┬──────────────────────────────────┘
                           │
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  GITHUB ACTIONS (Automated)                                  │
│                                                              │
│  am-sdk-publish.yml triggers                                 │
│     ↓ detect-changes: git diff                               │
│     ↓ java changed?    → publish-library.yml (language=java)  │
│     ↓ flutter changed? → publish-library.yml (language=flutter)│
│     ↓ python changed?  → publish-library.yml (language=python) │
│     ↓                                                         │
│     ↓ Published to GitHub Packages                            │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Final File Structure

```
am-portfolio/
├── .github/workflows/
│   ├── am-portfolio-publish.yml    ← [NEW] App deployment
│   └── am-sdk-publish.yml         ← [NEW] SDK publishing
│
└── am-portfolio-sdk/               ← [NEW] Complete directory
    ├── .gitignore                  ← [NEW] Ignore temp/build files
    ├── openapitools.json           ← [NEW] Generator version lock (7.18.0)
    ├── Ci-cd-implementation.md     ← [NEW] This documentation file
    ├── generate_sdks.ps1           ← [NEW] Master generation script
    ├── portfolio-openapi.json      ← [GENERATED] After running extraction
    │
    ├── scripts/
    │   ├── extract_portfolio_openapi.ps1  ← [NEW] Spec extractor (port 8060)
    │   └── generator/
    │       ├── Core.ps1            ← [NEW] Shared engine (Invoke-OpenApiGen)
    │       ├── Java.ps1            ← [NEW] Java generator + pom.xml
    │       ├── Flutter.ps1         ← [NEW] Dart generator + post-processing
    │       └── Python.ps1          ← [NEW] Python generator + pyproject.toml
    │
    ├── java-portfolio-sdk/         ← [GENERATED] After running generate_sdks.ps1
    ├── python-portfolio-sdk/       ← [GENERATED] After running generate_sdks.ps1
    └── flutter-portfolio-sdk/      ← [GENERATED] After running generate_sdks.ps1
```

---

**Status**: ✅ All files created and ready  
**Next Step**: Run `extract_portfolio_openapi.ps1` → `generate_sdks.ps1` → commit & push  
**Last Updated**: 2026-04-16
