import {
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Column,
  BeforeUpdate,
} from 'typeorm';

import { IUserToken } from '../seedworks/interface/user-token';
export abstract class AbstractEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @CreateDateColumn({ type: 'timestamp with time zone' })
  createdAt: Date;

  @UpdateDateColumn({ type: 'timestamp with time zone' })
  updatedAt: Date;

  @Column({ type: 'varchar' })
  createdBy: IUserToken['id'];

  @Column({ type: 'varchar' })
  updatedBy: IUserToken['id'];

  // property tạm thời lưu user id để hook sử dụng
  tempUpdatedBy?: string;

  @BeforeUpdate()
  setUpdatedBy() {
    if (this.tempUpdatedBy) {
      this.updatedBy = this.tempUpdatedBy;
    }
  }
}
