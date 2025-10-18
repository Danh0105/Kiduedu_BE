// src/policyservice/payment-policy.service.ts
import { Injectable, NotFoundException } from '@nestjs/common';
import { CreatePaymentPolicyDto } from './dto/create-payment-policy.dto';
import { UpdatePaymentPolicyDto } from './dto/update-payment-policy.dto';
import { PaymentPolicyResponse } from './dto/payment-policy.response';
import { PaymentPolicy } from './entities/payment-policy.entity'; // ví dụ

@Injectable()
export class PaymentPolicyService {
    // constructor(private readonly repo: Repository<PaymentPolicy>) {}

    private toResponse(e: PaymentPolicy): PaymentPolicyResponse {
        return {
            id: e.id,
            name: e.name,
            description: e.description ?? undefined,   // ⬅️ fix: null → undefined
            isActive: (e as any).isActive ?? (e as any).active ?? false,
            createdAt: e.createdAt,
            updatedAt: e.updatedAt,
        };
    }


    async create(dto: CreatePaymentPolicyDto): Promise<PaymentPolicyResponse> {
        const saved = await /* this.repo.save(...) */ {} as PaymentPolicy;
        return this.toResponse(saved);
    }

    async findAll(): Promise<PaymentPolicyResponse[]> {
        const rows = await /* this.repo.find() */[] as PaymentPolicy[];
        return rows.map(this.toResponse.bind(this));
    }

    async findOne(id: string): Promise<PaymentPolicyResponse> {
        const row = await /* this.repo.findOneBy({ id }) */ null as any as PaymentPolicy;
        if (!row) throw new NotFoundException('Payment policy not found');
        return this.toResponse(row);
    }

    async update(id: string, dto: UpdatePaymentPolicyDto): Promise<PaymentPolicyResponse> {
        // await this.repo.update(id, dto);
        const row = await /* this.repo.findOneBy({ id }) */ null as any as PaymentPolicy;
        if (!row) throw new NotFoundException('Payment policy not found');
        return this.toResponse(row);
    }

    // như đã trao đổi: trả boolean để controller quyết định throw/return
    async remove(id: string): Promise<boolean> {
        const res = await /* this.repo.delete(id) */ { affected: 1 as number | undefined };
        return !!res?.affected;
    }
}
