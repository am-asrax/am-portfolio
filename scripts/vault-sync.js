const fs = require('fs');
const path = require('path');
const net = require('net');

// Configuration
// Dummy commit to trigger pipeline test
const ENV_PATH = path.join(__dirname, '..', '.env');
const VAULT_URI = process.env.VAULT_URI || 'https://vault-local.munish.org';
const VAULT_TOKEN = process.env.VAULT_TOKEN;
if (!VAULT_TOKEN) {
    console.error('[ERROR] VAULT_TOKEN is missing! Please set it in your environment.');
    process.exit(1);
}

// The "Perfect" Vault paths provided by the user
const VAULT_SUBPATHS = [
    'local/apps/api',
    'local/apps/config',
    'local/apps/database',
    'local/apps/paas',
    'local/apps/security',
    'local/app/portfolio' // fallback to the previous one we created
];

async function loadEnv() {
    if (!fs.existsSync(ENV_PATH)) return {};
    const content = fs.readFileSync(ENV_PATH, 'utf8');
    const env = {};
    content.split('\n').forEach(line => {
        const match = line.match(/^\s*([\w.-]+)\s*=\s*(.*)?\s*$/);
        if (match) {
            env[match[1]] = match[2] ? match[2].trim() : '';
        }
    });
    return env;
}

async function fetchFromVaultPath(subpath) {
    const fullPath = `v1/secret/data/${subpath}`;
    console.log(`[VAULT] Checking ${subpath}...`);
    try {
        const response = await fetch(`${VAULT_URI}/${fullPath}`, {
            headers: { 'X-Vault-Token': VAULT_TOKEN }
        });
        if (!response.ok) {
            if (response.status === 404) return {};
            console.warn(`[WARN] Vault access failed for ${subpath} (Status ${response.status})`);
            return {};
        }
        const json = await response.json();
        const data = json.data.data || {};
        const count = Object.keys(data).length;
        if (count > 0) console.log(`[OK] Found ${count} keys in ${subpath}`);
        return data;
    } catch (error) {
        console.warn(`[WARN] Vault connection failed for ${subpath}: ${error.message}`);
        return {};
    }
}

async function checkConnectivity(host, port, name) {
    return new Promise((resolve) => {
        const socket = new net.Socket();
        socket.setTimeout(3000);
        socket.on('connect', () => {
            console.log(`[PASS] ${name} reachable at ${host}:${port}`);
            socket.destroy();
            resolve(true);
        });
        socket.on('timeout', () => {
            console.error(`[FAIL] ${name} connection timed out at ${host}:${port}`);
            socket.destroy();
            resolve(false);
        });
        socket.on('error', (err) => {
            console.error(`[FAIL] ${name} connection failed at ${host}:${port}: ${err.message}`);
            socket.destroy();
            resolve(false);
        });
        socket.connect(port, host);
    });
}

async function sync() {
    const existingEnv = await loadEnv();
    let aggregatedVaultSecrets = {};

    console.log('[VAULT] Beginning multi-path scan...');
    const vaultDataResults = await Promise.all(VAULT_SUBPATHS.map(subpath => fetchFromVaultPath(subpath)));
    vaultDataResults.forEach(data => {
        aggregatedVaultSecrets = { ...aggregatedVaultSecrets, ...data };
    });

    
    const finalEnv = { ...existingEnv, ...aggregatedVaultSecrets };

    // Priority Resolution Logic
    // 1. Vault (Highest priority, just merged)
    // 2. System ENV (Environment variables like Git Secrets)
    // 3. Current .env (Defaults if nothing else matches)
    
    // We also need to map specific keys if they use different names (e.g. MONGODB_HOST vs MONGODB_URL)
    if (finalEnv.MONGODB_HOST && finalEnv.MONGODB_PASSWORD && !finalEnv.MONGODB_URL) {
        const user = finalEnv.MONGODB_USERNAME || 'admin';
        finalEnv.MONGODB_URL = `mongodb://${user}:${finalEnv.MONGODB_PASSWORD}@${finalEnv.MONGODB_HOST}/?authSource=admin&directConnection=true`;
    }

    // Sort and format for .env
    const envContent = Object.entries(finalEnv)
        .sort(([a], [b]) => a.localeCompare(b))
        .map(([key, value]) => `${key}=${value}`)
        .join('\n');
    
    fs.writeFileSync(ENV_PATH, envContent + '\n');
    console.log(`\n[OK] Updated ${ENV_PATH} with ${Object.keys(finalEnv).length} keys total.\n`);

    // Infrastructure Check
    console.log('[INFRA] Verifying connectivity...');
    
    let mongoHost = finalEnv.MONGODB_HOST || 'localhost';
    let mongoPort = 27017;
    if (finalEnv.MONGODB_URL) {
        try {
            const tempUrl = finalEnv.MONGODB_URL.split('@')[1]?.split('/')[0] || finalEnv.MONGODB_URL.replace('mongodb://', '');
            const parts = tempUrl.split(':');
            mongoHost = parts[0];
            mongoPort = parts[1] ? parseInt(parts[1]) : 27017;
        } catch (e) {}
    }

    const checks = [
        checkConnectivity(mongoHost, mongoPort, 'MongoDB'),
        checkConnectivity(finalEnv.REDIS_HOSTNAME || 'localhost', finalEnv.REDIS_PORT || 6379, 'Redis'),
        checkConnectivity((finalEnv.KAFKA_BOOTSTRAP_SERVERS || 'localhost:9092').split(':')[0], parseInt((finalEnv.KAFKA_BOOTSTRAP_SERVERS || 'localhost:9092').split(':')[1] || 9092), 'Kafka')
    ];

    const results = await Promise.all(checks);
    if (results.includes(false)) {
        console.error('\n[!!] INFRASTRUCTURE WARNING: Verify your network or restart containers if necessary.');
    } else {
        console.log('\n[SUCCESS] Deployment-ready! Environment synced and services reachable.');
    }
}

if (require.main === module) {
    sync().catch(err => {
        console.error('[ERROR] Sync failed:', err);
        process.exit(1);
    });
}
