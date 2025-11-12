import { ConflictException, Logger, NotFoundException } from '@nestjs/common';
import {
  Repository,
  DataSource,
  EntityManager,
  FindOneOptions,
  FindManyOptions,
  ObjectLiteral,
  DeepPartial,
} from 'typeorm';
import { IUserToken } from '../seedworks/interface/user-token';

export abstract class AbstractRepository<TEntity extends ObjectLiteral> {
  protected abstract readonly logger: Logger;

  constructor(
    protected readonly repository: Repository<TEntity>,
    protected readonly dataSource: DataSource,
  ) {}

  async create(document: DeepPartial<TEntity>, user: IUserToken): Promise<TEntity> {
    const entity = this.repository.create({
      ...document,
      createdBy: user.id,
    });
    return this.repository.save(entity);
  }

  async findOne(filter: Partial<TEntity>, options?: FindOneOptions<TEntity>): Promise<TEntity> {
    const entity = await this.repository.findOne({ where: filter, ...options });
    if (!entity) {
      this.logger.warn('Entity not found with filter', filter);
      throw new NotFoundException('Entity not found.');
    }
    return entity;
  }

  async findOneAndUpdate(
    filter: Partial<TEntity>,
    update: Partial<TEntity>,
    user: IUserToken,
  ): Promise<TEntity> {
    const entity = await this.repository.findOne({ where: filter });
    if (!entity) {
      this.logger.warn('Entity not found with filter', filter);
      throw new NotFoundException('Entity not found.');
    }
    Object.assign(entity, update, { updatedBy: user.id, updatedAt: new Date() });
    return this.repository.save(entity);
  }

  async upsert(
    filter: Partial<TEntity>,
    document: DeepPartial<TEntity>,
    user: IUserToken,
  ): Promise<TEntity> {
    let entity = await this.repository.findOne({ where: filter });
    if (entity) {
      Object.assign(entity, document, { updatedBy: user.id, updatedAt: new Date() } as any);
    } else {
      entity = this.repository.create({
        ...document,
        updatedBy: user.id,
      });
    }
    return this.repository.save(entity);
  }

  async updateOne(
    filter: Partial<TEntity>,
    document: Partial<TEntity>,
    user: IUserToken,
  ): Promise<TEntity> {
    const entity = await this.repository.findOne({ where: filter });
    if (!entity) throw new NotFoundException('Entity not found.');
    Object.assign(entity, document, { updatedBy: user.id, updatedAt: new Date() } as any);
    return this.repository.save(entity);
  }

  async updateMany(
    filter: Partial<TEntity>,
    document: Partial<TEntity>,
    user: IUserToken,
  ): Promise<TEntity[]> {
    const entities = await this.repository.find({ where: filter });
    for (const entity of entities) {
      Object.assign(entity, document, { updatedBy: user.id, updatedAt: new Date() } as any);
    }
    return this.repository.save(entities);
  }

  async exists(filter: Partial<TEntity>): Promise<boolean> {
    const count = await this.repository.count({ where: filter });
    return count > 0;
  }

  async checkConflict(filter: Partial<TEntity>, message: string): Promise<void> {
    if (await this.exists(filter)) throw new ConflictException(message);
  }

  async runInTransaction<T>(operation: (manager: EntityManager) => Promise<T>): Promise<T> {
    return await this.dataSource.manager.transaction(operation);
  }

  async findMany(filter: Partial<TEntity>, options?: FindManyOptions<TEntity>): Promise<TEntity[]> {
    return this.repository.find({ where: filter, ...options });
  }
}
