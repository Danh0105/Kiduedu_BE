// src/policyservice/payment-policy.controller.ts
import { Controller, Get, Post, Body, Param, Patch, Delete, NotFoundException } from '@nestjs/common';
import { PaymentPolicyService } from './payment-policy.service';
import { CreatePaymentPolicyDto } from './dto/create-payment-policy.dto';
import { UpdatePaymentPolicyDto } from './dto/update-payment-policy.dto';
import { PaymentPolicyResponse } from './dto/payment-policy.response';

@Controller('payment-policy')
export class PaymentPolicyController {
    constructor(private readonly service: PaymentPolicyService) { }

    @Post()
    create(@Body() dto: CreatePaymentPolicyDto): Promise<PaymentPolicyResponse> {
        return this.service.create(dto);
    }

    @Get()
    findAll(): Promise<PaymentPolicyResponse[]> {
        return this.service.findAll();
    }

    @Get(':id')
    findOne(@Param('id') id: string): Promise<PaymentPolicyResponse> {
        return this.service.findOne(id);
    }

    @Patch(':id')
    update(
        @Param('id') id: string,
        @Body() dto: UpdatePaymentPolicyDto,
    ): Promise<PaymentPolicyResponse> {
        return this.service.update(id, dto);
    }

    @Delete(':id')
    async remove(@Param('id') id: string): Promise<{ deleted: true }> {
        const ok = await this.service.remove(id);
        if (!ok) {
            throw new NotFoundException('Payment policy not found');
        }
        return { deleted: true };
    }
}
