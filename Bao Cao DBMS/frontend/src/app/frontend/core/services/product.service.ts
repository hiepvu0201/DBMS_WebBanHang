import { Injectable } from "@angular/core";
import { HttpClient, HttpParams } from "@angular/common/http";
import { Observable } from "rxjs";
import { map } from "rxjs/operators";

import { Product } from "../models/product.model";

const API_URL = "https://localhost:5001/api/products";
const API_URL_WEB = "https://localhost:5001/api/web/products";

@Injectable({
  providedIn: "root"
})
export class ProductService {
  constructor(private http: HttpClient) {}

  getProducts() {
    return this.http.get<Product[]>(`${API_URL_WEB}`);
  }

  getProduct(id: number) {
    return this.http.get<Product>(`${API_URL}/${id}`);
  }

  getCatalogProductOptions(
    currentPage = 1,
    pageSize = 10,
    sortOrderName = "Id",
    sortOrder = "asc",
    searchValue
  ): Observable<Product[]> {
    return this.http
      .get<Product[]>(`${API_URL_WEB}/catalog`, {
        params: new HttpParams()
          .set("currentPage", currentPage.toString())
          .set("pageSize", pageSize.toString())
          .set("sortOrderName", sortOrderName)
          .set("sortOrder", sortOrder)
          .set("searchValue", searchValue)
      })
      .pipe(
        map(products => {
          return products;
        })
      );
  }
}
