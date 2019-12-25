import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";

import { Category } from "../models/category.model";

const API_URL = "https://localhost:5001/api/web/categories";

@Injectable({
  providedIn: "root"
})
export class CategoryService {
  constructor(private http: HttpClient) {}

  getCategories() {
    return this.http.get<Category[]>(`${API_URL}`);
  }
}
