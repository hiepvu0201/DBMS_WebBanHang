import { CustomerModel } from "./customer.model";

export class OrderModel {
  id: number;
  orderDate: string;
  customerId: number;
  cutomer: CustomerModel;
}
