import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";

const API_URL = "https://localhost:5001/api/dashboard";

@Injectable({
  providedIn: "root"
})
export class DashboardService {
  constructor(private http: HttpClient) {}

  getCatalogCount() {
    return this.http.get<number>(`${API_URL}/catalogs`);
  }

  getProductCount() {
    return this.http.get<number>(`${API_URL}/products`);
  }

  getCategoryCount() {
    return this.http.get<number>(`${API_URL}/categories`);
  }

  getPostCount() {
    return this.http.get<number>(`${API_URL}/posts`);
  }

  getOrderCount() {
    return this.http.get<number>(`${API_URL}/orders`);
  }

  getTotalPrice() {
    return this.http.get<number>(`${API_URL}/totalIncome`);
  }
}
