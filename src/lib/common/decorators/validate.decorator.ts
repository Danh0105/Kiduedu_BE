import {
  ArrayNotEmpty,
  IsEnum,
  IsNotEmpty,
  IsNumber,
  IsOptional,
  IsString,
  ValidateNested,
} from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export function Optional(): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiPropertyOptional()(target, propertyKey);
    IsOptional()(target, propertyKey);
  };
}

export function Text(): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiPropertyOptional()(target, propertyKey);
    IsOptional()(target, propertyKey);
    IsString()(target, propertyKey);
  };
}

export function TextRequired(): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiProperty()(target, propertyKey);
    IsString()(target, propertyKey);
    IsNotEmpty()(target, propertyKey);
  };
}

export function Number(): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiPropertyOptional()(target, propertyKey);
    IsOptional()(target, propertyKey);
    IsNumber()(target, propertyKey);
  };
}

export function NumberRequired(): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiProperty()(target, propertyKey);
    IsNumber()(target, propertyKey);
    IsNotEmpty()(target, propertyKey);
  };
}

export function Enum(object: object): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiPropertyOptional()(target, propertyKey);
    IsOptional()(target, propertyKey);
    IsEnum(object)(target, propertyKey);
  };
}

export function ArrayNested(): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiPropertyOptional()(target, propertyKey);
    IsOptional()(target, propertyKey);
    ArrayNotEmpty()(target, propertyKey);
    ValidateNested({ each: true })(target, propertyKey);
  };
}

export function ObjectNested(): PropertyDecorator {
  return function (target: any, propertyKey: string | symbol) {
    ApiPropertyOptional()(target, propertyKey);
    IsOptional()(target, propertyKey);
    ValidateNested({ each: true })(target, propertyKey);
  };
}
