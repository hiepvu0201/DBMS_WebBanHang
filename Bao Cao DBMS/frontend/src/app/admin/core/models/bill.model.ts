import { ProductModel } from "./product.model";

export class BillModel {
  firstName: string;
  lastName: string;
  phone: string;
  email: string;
  address: string;
  city: string;
  note: string;
  orderDate: string;
  orderId: number;
  product: ProductModel;
  quantity: number;
}
