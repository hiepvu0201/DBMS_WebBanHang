import { Category } from "./category.model";

export class Post {
  id: number;
  title: string;
  shortDescription: string;
  content: string;
  image: string;
  categoryId: number;
  category: Category;
  createdAt: string;
  updatedAt: string;
}
