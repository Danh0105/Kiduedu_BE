// src/crypto/crypto-key.service.ts
import { Injectable } from '@nestjs/common';
import * as crypto from 'crypto';
import * as fs from 'fs';
import * as path from 'path';

@Injectable()
export class CryptoKeyService {
    private readonly privateKey: string;
    private readonly publicKey: string;
    private readonly notifyCert: string; // 👈 BỔ SUNG

    constructor() {
        const privateKeyPath = process.env.VIETINBANK_PRIVATE_KEY_PATH;
        const publicKeyPath = process.env.VIETINBANK_PUBLIC_KEY_PATH;
        const notifyCertPath = process.env.VIETINBANK_NOTIFY_CERT_PATH; // 👈 BỔ SUNG

        if (!privateKeyPath) {
            throw new Error('VIETINBANK_PRIVATE_KEY_PATH is not defined');
        }

        if (!publicKeyPath) {
            throw new Error('VIETINBANK_PUBLIC_KEY_PATH is not defined');
        }

        if (!notifyCertPath) {
            throw new Error('VIETINBANK_NOTIFY_CERT_PATH is not defined');
        }

        const resolvedPrivate = path.resolve(privateKeyPath);
        const resolvedPublic = path.resolve(publicKeyPath);
        const resolvedNotifyCert = path.resolve(notifyCertPath);

        if (!fs.existsSync(resolvedPrivate)) {
            throw new Error(`Private key not found: ${resolvedPrivate}`);
        }

        if (!fs.existsSync(resolvedPublic)) {
            throw new Error(`Public key not found: ${resolvedPublic}`);
        }

        if (!fs.existsSync(resolvedNotifyCert)) {
            throw new Error(`Notify cert not found: ${resolvedNotifyCert}`);
        }

        this.privateKey = fs.readFileSync(resolvedPrivate, 'utf8');
        this.publicKey = fs.readFileSync(resolvedPublic, 'utf8');
        this.notifyCert = fs.readFileSync(resolvedNotifyCert, 'utf8');

        console.log('🔐 CryptoKeyService loaded keys successfully');
    }


    verify(data: string, signature: string): boolean {
        try {
            const verifier = crypto.createVerify('RSA-SHA256');

            verifier.update(Buffer.from(data, 'utf8'));
            verifier.end();

            const cleanSignature = signature.replace(/[\r\n]/g, '')


            return verifier.verify(
                {
                    key: this.notifyCert,
                    padding: crypto.constants.RSA_PKCS1_PADDING

                },
                Buffer.from(cleanSignature, 'base64'),
            );
        } catch (e) {
            console.error('VERIFY ERROR:', e);
            return false;
        }
    }




    /** 👈 DÙNG RIÊNG CHO VIETINBANK NOTIFY */
    verifyNotify(data: string, signature: string): boolean {
        const verifier = crypto.createVerify('RSA-SHA256');
        verifier.update(data);
        verifier.end();

        return verifier.verify(
            this.notifyCert,
            Buffer.from(signature, 'base64'),
        );
    }

    /** Ký response trả VietinBank */
    sign(data: string): string {
        const signer = crypto.createSign('RSA-SHA256');
        signer.update(data, 'utf8');
        signer.end();

        return signer.sign(this.privateKey, 'base64');
    }
}
