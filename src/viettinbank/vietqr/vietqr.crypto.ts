// src/viettinbank/vietqr/vietqr.crypto.ts
import * as crypto from 'crypto';
import * as fs from 'fs';

export function signData(
    data: string,
    privateKeyPath: string,
): string {
    const privateKey = fs.readFileSync(privateKeyPath, 'utf8');

    const signer = crypto.createSign('RSA-SHA256');
    signer.update(data);
    signer.end();

    return signer.sign(privateKey, 'base64');
}

export function verifySignature(
    data: string,
    signature: string,
    publicKeyPath: string,
): boolean {
    const publicKey = fs.readFileSync(publicKeyPath, 'utf8');

    const verifier = crypto.createVerify('RSA-SHA256');
    verifier.update(data);
    verifier.end();

    return verifier.verify(publicKey, signature, 'base64');
}
