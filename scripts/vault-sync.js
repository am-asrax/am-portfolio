/**
 * ============================================================
 *  AM Portfolio - Vault Sync Script
 * ============================================================
 *  USAGE:
 *    Pull (sync from Vault → .env-<env>):
 *      node scripts/vault-sync.js <env>
 *      node scripts/vault-sync.js preprod
 *
 *    Push (seed Vault from .env or .env-<env>):
 *      node scripts/vault-sync.js <env> --push
 *
 *  BEHAVIOUR:
 *    --push mode:
 *      1. Categorises keys from the source .env file.
 *      2. For each category (database, paas, security, api, config):
 *         - Checks if the Vault path already has keys.
 *         - If path is EMPTY → pushes the categorised values.
 *         - If path has data → skips (never overwrites existing secrets).
 *      3. Saves a timestamped backup of the source .env.
 *
 *    --pull mode (default):
 *      1. Fetches all category paths for the target environment from Vault.
 *      2. Merges all fetched keys into a single flat object.
 *      3. Backs up any existing .env-<env> file.
 *      4. Writes the merged secrets to .env-<env>.
 * ============================================================
 */

'use strict';

const fs   = require('fs');
const path = require('path');
const net  = require('net');

// ─── CLI Arguments ────────────────────────────────────────────────────────────
const args   = process.argv.slice(2);
const ENV    = args.find(a => !a.startsWith('--')) || 'preprod';
const isPush = args.includes('--push');
const isPull = !isPush;
const isForce = args.includes('--force');

// ─── Paths ────────────────────────────────────────────────────────────────────
const PROJECT_ROOT       = path.join(__dirname, '..');
const ENV_FILE           = path.join(PROJECT_ROOT, `.env-${ENV}`);      // e.g. .env-preprod
const BASE_ENV_FILE      = path.join(PROJECT_ROOT, '.env');              // Fallback base .env
const BACKUP_DIR         = path.join(PROJECT_ROOT, '.env-backups');
const DEFAULT_CREDS_PATH = path.join(
    PROJECT_ROOT, '..', '..', 'am-infra', 'infrastructure-secrets', 'latest', 'credentials.txt'
);

// ─── Vault Auth ───────────────────────────────────────────────────────────────
let VAULT_URI   = process.env.VAULT_URI   || 'https://vault.munish.org';
let VAULT_TOKEN = process.env.VAULT_TOKEN || '';

// ─── Vault Mount ──────────────────────────────────────────────────────────────
const VAULT_MOUNT = 'kv';

// ─── Vault Path Structure ────────────────────────────────────────────────────
// User-Requested Structure:
//   <env>/infra                  → Shared (JWT, Config, etc.)
//   <env>/apps/portfolio/database/mongo
//   <env>/apps/portfolio/database/redis
//   <env>/apps/portfolio/database/postgres
//   <env>/apps/portfolio/database/influxdb
//   <env>/apps/portfolio/kafka
//   <env>/apps/portfolio/api/upstock
//   <env>/apps/portfolio/api/zerodha
//   <env>/apps/portfolio/app     → App-specific catch-all
const CATEGORY_TO_PATH = {
    infra:      'infra',
    mongodb:    'apps/portfolio/database/mongo',
    redis:      'apps/portfolio/database/redis',
    postgresql: 'apps/portfolio/database/postgres',
    influxdb:   'apps/portfolio/database/influxdb',
    kafka:      'apps/portfolio/kafka',
    upstox:     'apps/portfolio/api/upstock',
    zerodha:    'apps/portfolio/api/zerodha',
    portfolio:  'apps/portfolio' 
};
const ALL_CATEGORIES = Object.keys(CATEGORY_TO_PATH);
const vaultSubpaths  = (env) => ALL_CATEGORIES.map(cat => `${env}/${CATEGORY_TO_PATH[cat]}`);

// ─── Key Categorisation Rules ─────────────────────────────────────────────────
// Note: Following user's specific request to put JWT/Config in 'infra'
// and DBs into granular 'apps/portfolio' subpaths.
const CATEGORY_RULES = {
    infra:      ['JWT_', 'SSL_', 'TOGETHER_', 'VAULT_'], 
    mongodb:    ['MONGODB_', 'MONGO_'],
    redis:      ['REDIS_'],
    postgresql: ['POSTGRES_', 'POSTGRES_'],
    influxdb:   ['INFLUXDB_', 'INFLUX_'],
    kafka:      ['KAFKA_'],
    upstox:     ['UPSTOX_'],
    zerodha:    ['ZERODHA_'],
    portfolio:  []  // catch-all -> apps/portfolio
};

// ─── Helper: Backup ──────────────────────────────────────────────────────────
function backupFile(filePath) {
    if (!fs.existsSync(filePath)) return;
    if (!fs.existsSync(BACKUP_DIR)) fs.mkdirSync(BACKUP_DIR, { recursive: true });
    const ts = new Date().toISOString().replace(/[:.]/g, '-');
    const base = path.basename(filePath);
    const bakPath = path.join(BACKUP_DIR, `${base}.${ts}.bak`);
    fs.copyFileSync(filePath, bakPath);
    console.log(`[BACKUP] ${filePath} → ${bakPath}`);
}

// ─── Helper: Parse .env file ──────────────────────────────────────────────────
function parseEnvFile(filePath) {
    if (!fs.existsSync(filePath)) return {};
    const content = fs.readFileSync(filePath, 'utf8');
    const env = {};
    for (const line of content.split('\n')) {
        const trimmed = line.trim();
        if (!trimmed || trimmed.startsWith('#')) continue;
        const eqIdx = trimmed.indexOf('=');
        if (eqIdx === -1) continue;
        const key = trimmed.slice(0, eqIdx).trim();
        const val = trimmed.slice(eqIdx + 1).trim();
        if (key) env[key] = val;
    }
    return env;
}

// ─── Helper: Resolve Vault Credentials ───────────────────────────────────────
function resolveVaultAuth() {
    // 1. From environment-specific .env file
    let envFileData = parseEnvFile(ENV_FILE);
    if (!envFileData.VAULT_TOKEN) envFileData = parseEnvFile(BASE_ENV_FILE);

    if (!VAULT_TOKEN && envFileData.VAULT_TOKEN) {
        VAULT_TOKEN = envFileData.VAULT_TOKEN;
        console.log('[AUTH] Token resolved from .env file.');
    }
    if (envFileData.VAULT_URI) {
        VAULT_URI = envFileData.VAULT_URI;
    }

    // 2. Fallback: local credentials.txt (am-auth runner pattern)
    if (!VAULT_TOKEN && fs.existsSync(DEFAULT_CREDS_PATH)) {
        const creds = fs.readFileSync(DEFAULT_CREDS_PATH, 'utf8');
        const tokenMatch = creds.match(/Token:\s*(hvs\.[a-zA-Z0-9]+)/);
        const urlMatch   = creds.match(/Vault URL:\s*(https?:\/\/[^\s]+)/);
        if (tokenMatch) { VAULT_TOKEN = tokenMatch[1]; console.log('[AUTH] Token resolved from credentials.txt.'); }
        if (urlMatch)   { VAULT_URI   = urlMatch[1]; }
    }

    if (!VAULT_TOKEN) {
        console.error('[ERROR] No VAULT_TOKEN found in .env, credentials.txt, or environment!');
        process.exit(1);
    }
    console.log(`[AUTH] Vault: ${VAULT_URI}  Token: ${VAULT_TOKEN.slice(0, 12)}...`);
}

// ─── Helper: Vault GET (read) ─────────────────────────────────────────────────
async function vaultGet(subpath) {
    const url = `${VAULT_URI}/v1/${VAULT_MOUNT}/data/${subpath}`;
    try {
        const res = await fetch(url, { headers: { 'X-Vault-Token': VAULT_TOKEN } });
        if (res.status === 404) return null;           // Path does not exist
        if (!res.ok) {
            console.warn(`[WARN] GET ${subpath} → HTTP ${res.status}`);
            return null;
        }
        const json = await res.json();
        return json?.data?.data ?? {};
    } catch (err) {
        console.warn(`[WARN] GET ${subpath} failed: ${err.message}`);
        return null;
    }
}

// ─── Helper: Vault PUT (write) ────────────────────────────────────────────────
async function vaultPut(subpath, data) {
    const url  = `${VAULT_URI}/v1/${VAULT_MOUNT}/data/${subpath}`;
    const body = JSON.stringify({ data });
    try {
        const res = await fetch(url, {
            method:  'POST',
            headers: { 'X-Vault-Token': VAULT_TOKEN, 'Content-Type': 'application/json' },
            body
        });
        if (res.ok || res.status === 204) return true;
        const errText = await res.text();
        console.error(`[ERROR] PUT ${subpath} → HTTP ${res.status}: ${errText}`);
        return false;
    } catch (err) {
        console.error(`[ERROR] PUT ${subpath} failed: ${err.message}`);
        return false;
    }
}

// ─── Helper: Categorise env keys ─────────────────────────────────────────────
function categoriseKeys(envObj) {
    const categories = {};
    for (const cat of ALL_CATEGORIES) categories[cat] = {};
    const SKIP_KEYS = ['VAULT_TOKEN', 'VAULT_URI', 'GITHUB_PACKAGES_TOKEN', 'PYPI_API_TOKEN'];

    for (const [key, val] of Object.entries(envObj)) {
        if (SKIP_KEYS.includes(key)) continue;
        if (!val || val.includes('(Add here)')) continue; // Skip placeholders

        let placed = false;
        for (const [cat, rules] of Object.entries(CATEGORY_RULES)) {
            if (cat === 'portfolio') continue; // catch-all last
            if (rules.some(r => key.toUpperCase().startsWith(r) || key.toUpperCase().includes(r))) {
                categories[cat][key] = val;
                placed = true;
                break;
            }
        }
        if (!placed) categories.portfolio[key] = val;
    }
    return categories;
}

// ─── Connectivity Check ───────────────────────────────────────────────────────
function checkConnectivity(host, port, name) {
    return new Promise((resolve) => {
        const socket = new net.Socket();
        socket.setTimeout(3000);
        socket.on('connect', () => { console.log(`[PASS] ${name} @ ${host}:${port}`); socket.destroy(); resolve(true); });
        socket.on('timeout', () => { console.error(`[FAIL] ${name} timed out @ ${host}:${port}`); socket.destroy(); resolve(false); });
        socket.on('error',  (e) => { console.error(`[FAIL] ${name} @ ${host}:${port} — ${e.message}`); socket.destroy(); resolve(false); });
        socket.connect(port, host);
    });
}

// ══════════════════════════════════════════════════════════════════════════════
//  PUSH  (seed Vault from local .env)
// ══════════════════════════════════════════════════════════════════════════════
async function push() {
    console.log(`\n${'═'.repeat(60)}`);
    console.log(`  PUSH MODE  →  Seeding Vault for environment: ${ENV.toUpperCase()}`);
    console.log(`${'═'.repeat(60)}\n`);

    resolveVaultAuth();

    // Load source file: prefer .env-<env>, fall back to base .env
    const sourcePath = fs.existsSync(ENV_FILE) ? ENV_FILE : BASE_ENV_FILE;
    console.log(`[SOURCE] Reading from: ${sourcePath}`);
    const sourceEnv = parseEnvFile(sourcePath);

    if (Object.keys(sourceEnv).length === 0) {
        console.error('[ERROR] Source .env file is empty or missing!');
        process.exit(1);
    }

    backupFile(sourcePath);

    const categories = categoriseKeys(sourceEnv);

    console.log('\n[VAULT] Starting seed check per category...\n');

    let pushed = 0;
    let skipped = 0;

    for (const cat of ALL_CATEGORIES) {
        const vaultPath = `${ENV}/${CATEGORY_TO_PATH[cat]}`;
        const localData = categories[cat];
        const keyCount  = Object.keys(localData).length;

        if (keyCount === 0) {
            console.log(`[SKIP]  ${vaultPath}  (no local keys for this category)`);
            skipped++;
            continue;
        }

        // Check if path already has data in Vault
        process.stdout.write(`[CHECK] ${vaultPath} ... `);
        const existing = await vaultGet(vaultPath);

        if (existing && Object.keys(existing).length > 0 && !isForce) {
            console.log(`ALREADY HAS ${Object.keys(existing).length} KEYS — skipping (use --force to overwrite)`);
            skipped++;
            continue;
        }

        if (isForce && existing && Object.keys(existing).length > 0) {
            console.log(`OVERWRITING ${Object.keys(existing).length} existing keys...`);
        } else {
            console.log(`EMPTY — pushing ${keyCount} keys`);
        }
        const ok = await vaultPut(vaultPath, localData);
        if (ok) {
            console.log(`[OK]    ${vaultPath} → ${Object.keys(localData).join(', ')}`);
            pushed++;
        }
    }

    console.log(`\n${'─'.repeat(60)}`);
    console.log(`[DONE] Push complete. ${pushed} paths seeded, ${skipped} skipped.\n`);
}

// ══════════════════════════════════════════════════════════════════════════════
//  PULL  (sync from Vault → .env-<env>)
// ══════════════════════════════════════════════════════════════════════════════
async function pull() {
    console.log(`\n${'═'.repeat(60)}`);
    console.log(`  PULL MODE  →  Syncing from Vault for: ${ENV.toUpperCase()}`);
    console.log(`${'═'.repeat(60)}\n`);

    resolveVaultAuth();

    const paths   = vaultSubpaths(ENV);
    console.log('[VAULT] Fetching from paths:', paths);

    const results = await Promise.all(paths.map(p => vaultGet(p)));

    let merged = {};
    paths.forEach((p, i) => {
        const data = results[i];
        if (!data || Object.keys(data).length === 0) {
            console.log(`[EMPTY] ${p}`);
            return;
        }
        console.log(`[OK]    ${p}  → ${Object.keys(data).length} keys`);
        merged = { ...merged, ...data };
    });

    if (Object.keys(merged).length === 0) {
        console.warn('\n[WARN] Nothing pulled from Vault. Have you run with --push first?\n');
        return;
    }

    // Backup existing .env-<env>
    backupFile(ENV_FILE);

    // Write environment-specific .env
    const envContent = Object.entries(merged)
        .sort(([a], [b]) => a.localeCompare(b))
        .map(([k, v]) => `${k}=${v}`)
        .join('\n');

    fs.writeFileSync(ENV_FILE, envContent + '\n');
    console.log(`\n[OK] Written ${Object.keys(merged).length} keys to ${ENV_FILE}\n`);

    // Infrastructure Connectivity Check
    console.log('[INFRA] Checking service connectivity...');
    let mongoHost = merged.MONGODB_HOST || 'localhost';
    const mongoPort = parseInt(merged.MONGODB_PORT || '27017');
    const redisHost = merged.REDIS_HOST || merged.REDIS_HOSTNAME || 'localhost';
    const redisPort = parseInt(merged.REDIS_PORT || '6379');
    const [kafkaHost, kafkaPort] = (merged.KAFKA_BOOTSTRAP_SERVERS || 'localhost:9092').split(':');

    const checks = await Promise.all([
        checkConnectivity(mongoHost, mongoPort, 'MongoDB'),
        checkConnectivity(redisHost, redisPort, 'Redis'),
        checkConnectivity(kafkaHost, parseInt(kafkaPort || '9092'), 'Kafka'),
    ]);

    if (checks.includes(false)) {
        console.error('\n[!!] INFRA WARNING: Some services unreachable. Check your VPN/network.\n');
    } else {
        console.log('\n[SUCCESS] All services reachable. Deployment-ready!\n');
    }
}

// ─── Entrypoint ───────────────────────────────────────────────────────────────
if (require.main === module) {
    (isPush ? push() : pull()).catch(err => {
        console.error('[FATAL]', err);
        process.exit(1);
    });
}

module.exports = { push, pull };
