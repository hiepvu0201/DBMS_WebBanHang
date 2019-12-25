import { BaseModel } from "./base.model";

export class CategorieModel extends BaseModel {
  name: string;
  visibility: boolean;
  postCount: number;
}
