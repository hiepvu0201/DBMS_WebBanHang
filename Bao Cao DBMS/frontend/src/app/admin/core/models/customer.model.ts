import { BaseModel } from "./base.model";

export class CustomerModel extends BaseModel {
  name?: string;
  phone?: string;
  email?: string;
  address?: number;
  city?: string;
  note?: number;
}
