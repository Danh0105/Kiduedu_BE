// src/policyservice/dto/update-payment-policy.dto.ts
import { PartialType } from '@nestjs/mapped-types';
import { CreatePaymentPolicyDto } from './create-payment-policy.dto';

export class UpdatePaymentPolicyDto extends PartialType(CreatePaymentPolicyDto) { }
