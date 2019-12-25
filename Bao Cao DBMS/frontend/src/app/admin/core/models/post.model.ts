import { BaseModel } from "./base.model";
import { CategorieModel } from "./categories.mode";

export class PostModel extends BaseModel {
  title?: string;
  shortDescription?: string;
  content?: string = "";
  image?: string;
  visibility: boolean;
  categoryId?: number;
  category: CategorieModel;
}
