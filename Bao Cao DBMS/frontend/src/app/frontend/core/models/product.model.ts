export class Product {
  id: number;
  name?: string;
  shortDescription?: string;
  description?: string = "";
  price?: number;
  image?: string;
  visibility?: boolean;
  catalogsId?: number;
  updatedAt: string;
}
