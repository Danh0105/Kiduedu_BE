// src/modules/rental-orders/enums/rental-order-item.enums.ts
export enum RentalType {
  DAY = 'day',
  WEEK = 'week',
  MONTH = 'month',
}

export enum ReturnStatus {
  PENDING = 'pending',
  RETURNED = 'returned',
  LATE = 'late',
  LOST = 'lost',
}
