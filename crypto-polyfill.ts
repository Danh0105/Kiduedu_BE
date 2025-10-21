// Preload an toàn đa phiên bản Node
try {
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const nodeCrypto = require('crypto');

    // Chỉ tạo nếu CHƯA có. Tránh đụng Node 18/20/22 (crypto đã là getter chỉ-đọc).
    if (typeof globalThis.crypto === 'undefined') {
        const value = nodeCrypto.webcrypto ?? nodeCrypto;
        Object.defineProperty(globalThis, 'crypto', {
            value,
            configurable: true,
            enumerable: false,
            writable: false, // không cần ghi đè
        });
    }
} catch { /* bỏ qua nếu môi trường lạ */ }
