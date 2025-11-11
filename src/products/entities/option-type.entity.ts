import {
    Entity,
    PrimaryGeneratedColumn,
    Column,
    OneToMany,
    CreateDateColumn,
    UpdateDateColumn,
} from 'typeorm';
import { OptionValue } from './option-value.entity';

@Entity({ name: 'option_types' })
export class OptionType {
    @PrimaryGeneratedColumn({ name: 'option_type_id' })
    optionTypeId: number;

    @Column({ type: 'varchar', length: 100 })
    name: string;

    @Column({ type: 'integer', default: 0 })
    position: number;


    // Quan hệ: 1 loại option có nhiều giá trị
    @OneToMany(() => OptionValue, (optionValue) => optionValue.optionType)
    optionValues: OptionValue[];
}
