import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { HttpClient, HttpParams } from "@angular/common/http";
import { map } from "rxjs/operators";
import { ProductModel } from "../models/product.model";

const API_URL = "https://localhost:5001/api/products";

@Injectable({
  providedIn: "root"
})
export class ProductService {
  constructor(private http: HttpClient) {}

  findAllOtions(
    currentPage = 1,
    pageSize = 10,
    sortOrderName = "Id",
    sortOrder = "asc",
    searchValue = ""
  ): Observable<any> {
    return this.http
      .get(API_URL, {
        params: new HttpParams()
          .set("currentPage", currentPage.toString())
          .set("pageSize", pageSize.toString())
          .set("sortOrderName", sortOrderName)
          .set("sortOrder", sortOrder)
          .set("searchValue", searchValue)
      })
      .pipe(
        map(res => {
          return res;
        })
      );
  }

  getProductsCount() {
    return this.http.get<number>(`${API_URL}/count`);
  }

  getProduct(id) {
    return this.http.get<ProductModel>(`${API_URL}/${id}`);
  }

  addProduct(data) {
    const productData = new FormData();
    productData.append("name", data.name);
    productData.append("shortDescription", data.shortDescription);
    productData.append("description", data.description);
    productData.append("price", data.price);
    productData.append("file", data.image);
    productData.append("catalogId", data.catalogId);
    productData.append("visibility", data.visibility);
    return this.http.post<ProductModel>(API_URL, productData);
  }

  editProduct(id, data) {
    const productData = new FormData();
    productData.append("name", data.name);
    productData.append("shortDescription", data.shortDescription);
    productData.append("description", data.description);
    productData.append("price", data.price);
    productData.append("catalogId", data.catalogId);
    productData.append("visibility", data.visibility);

    if (data.image) {
      productData.append("file", data.image);
    }

    return this.http.put<ProductModel>(`${API_URL}/${id}`, productData);
  }

  deleteProduct(id) {
    return this.http.delete(`${API_URL}/${id}`);
  }
}
