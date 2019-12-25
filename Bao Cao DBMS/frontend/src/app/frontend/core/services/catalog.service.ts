import { Injectable } from "@angular/core";
import { HttpClient } from "@angular/common/http";

import { Catalog } from "../models/catalog.model";

const API_URL = "https://localhost:5001/api/web/catalogs";

@Injectable({
  providedIn: "root"
})
export class CatalogService {
  constructor(private http: HttpClient) {}

  getCatalog() {
    return this.http.get<Catalog[]>(`${API_URL}`);
  }
}
