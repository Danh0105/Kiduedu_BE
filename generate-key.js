// generate-key.js
const { generateKeyPairSync } = require('crypto');
const fs = require('fs');
const path = require('path');

const certDir = path.join(__dirname, 'certs');
if (!fs.existsSync(certDir)) {
    fs.mkdirSync(certDir);
}

const { privateKey, publicKey } = generateKeyPairSync('rsa', {
    modulusLength: 2048,
    publicKeyEncoding: {
        type: 'pkcs1',
        format: 'pem',
    },
    privateKeyEncoding: {
        type: 'pkcs1',
        format: 'pem',
    },
});

fs.writeFileSync(path.join(certDir, 'partner_private.key'), privateKey);
fs.writeFileSync(path.join(certDir, 'partner_public.key'), publicKey);

console.log('✅ RSA key pair generated in /certs');
