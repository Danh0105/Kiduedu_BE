import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('banners')
export class Banner {
  @PrimaryGeneratedColumn()
  banner_id: number;

  @Column({ length: 100 })
  title: string;

  @Column({ length: 255 })
  image_url: string;

  @Column({ length: 255, nullable: true })
  link_url: string;

  @Column({ type: 'enum', enum: ['homepage_slider', 'category_top', 'sidebar'] })
  position: 'homepage_slider' | 'category_top' | 'sidebar';

  @Column({ type: 'int', default: 0 })
  display_order: number;

  @Column({ default: true })
  is_active: boolean;
}
