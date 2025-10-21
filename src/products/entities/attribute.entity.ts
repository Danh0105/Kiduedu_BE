import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { CategoryAttribute } from './category-attribute.entity';

@Entity('attributes')
export class Attribute {
  @PrimaryGeneratedColumn()
  attribute_id: number;

  @Column({ unique: true, length: 100 })
  attribute_name: string;

  @Column({ length: 20 })
  value_type: string;

  @OneToMany(() => CategoryAttribute, (ca) => ca.attribute)
  categoryAttributes: CategoryAttribute[];

}
