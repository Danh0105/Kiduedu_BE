// src/policyservice/dto/payment-policy.response.ts
export class PaymentPolicyResponse {
  id: string;
  name: string;
  description?: string;
  isActive: boolean;      // API field
  createdAt: Date;
  updatedAt: Date;
}
