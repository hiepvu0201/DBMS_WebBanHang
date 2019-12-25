import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { HttpClient, HttpParams } from "@angular/common/http";
import { map } from "rxjs/operators";

const API_URL = "https://localhost:5001/api/orders";

@Injectable({
  providedIn: "root"
})
export class OrderService {
  constructor(private http: HttpClient) {}

  findAllOtions(
    currentPage = 1,
    pageSize = 10,
    sortOrderName = "",
    sortOrder = "asc",
    searchValue = ""
  ): Observable<any> {
    return this.http
      .get(`${API_URL}`, {
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

  getDetail(id: number) {
    return this.http.get(`${API_URL}/${id}`);
  }
}
