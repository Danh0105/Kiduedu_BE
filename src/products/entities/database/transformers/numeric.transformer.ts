// src/database/transformers/numeric.transformer.ts
export class NumericTransformer {
  to(value?: number | null): number | null | undefined {
    return value as any;
  }
  from(value?: string | null): number | null | undefined {
    return typeof value === 'string' ? parseFloat(value) : (value as any);
  }
}
