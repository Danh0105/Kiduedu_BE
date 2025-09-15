import { Expose } from 'class-transformer';

export class PaginationMetaDto {
  @Expose()
  total: number;

  @Expose()
  page: number;

  @Expose()
  limit: number;

  @Expose()
  last_page: number;
}

export class PaginatedResponseDto<T> {
  @Expose()
  success: boolean;

  @Expose()
  message: string;

  @Expose()
  statusCode: number;

  @Expose()
  meta: PaginationMetaDto;

  @Expose()
  data: T[];
}
