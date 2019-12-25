import { BaseModel } from "./base.model";

export class CatalogsModel extends BaseModel {
  name: string;
  visibility: boolean;
  productCount: number;
}
