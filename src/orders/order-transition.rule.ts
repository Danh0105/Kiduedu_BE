import { OrderStatus } from './order-status.enum';

export const ORDER_TRANSITIONS: Record<OrderStatus, OrderStatus[]> = {
    [OrderStatus.Pending]: [
        OrderStatus.Confirmed,
        OrderStatus.Cancelled,
    ],
    [OrderStatus.Confirmed]: [
        OrderStatus.Shipping,
        OrderStatus.Cancelled,
    ],
    [OrderStatus.Shipping]: [
        OrderStatus.Completed,
    ],
    [OrderStatus.Completed]: [],
    [OrderStatus.Cancelled]: [],
};

export function canTransition(
    from: OrderStatus,
    to: OrderStatus,
): boolean {
    return ORDER_TRANSITIONS[from]?.includes(to) ?? false;
}
