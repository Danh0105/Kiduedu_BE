// src/crypto/crypto-key.service.ts
import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class CryptoKeyService {
    private readonly privateKey: string;
    private readonly publicKey: string;

    constructor() {
        const privateKeyPath = process.env.VIETINBANK_PRIVATE_KEY_PATH;
        const publicKeyPath = process.env.VIETINBANK_PUBLIC_KEY_PATH;

        if (!privateKeyPath) {
            throw new Error('VIETINBANK_PRIVATE_KEY_PATH is not defined');
        }

        if (!publicKeyPath) {
            throw new Error('VIETINBANK_PUBLIC_KEY_PATH is not defined');
        }

        const resolvedPrivate = path.resolve(privateKeyPath);
        const resolvedPublic = path.resolve(publicKeyPath);

        if (!fs.existsSync(resolvedPrivate)) {
            throw new Error(`Private key not found: ${resolvedPrivate}`);
        }

        if (!fs.existsSync(resolvedPublic)) {
            throw new Error(`Public key not found: ${resolvedPublic}`);
        }

        this.privateKey = fs.readFileSync(resolvedPrivate, 'utf8');
        this.publicKey = fs.readFileSync(resolvedPublic, 'utf8');

        console.log('🔐 CryptoKeyService loaded keys successfully');
    }

    sign(data: string): string {
        const signer = crypto.createSign('RSA-SHA256');
        signer.update(data);
        signer.end();

        return signer.sign(this.privateKey, 'base64');
    }

    verify(data: string, signature: string): boolean {
        const verifier = crypto.createVerify('RSA-SHA256');
        verifier.update(data);
        verifier.end();

        return verifier.verify(this.publicKey, signature, 'base64');
    }
}
