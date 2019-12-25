import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { HttpClient, HttpParams } from "@angular/common/http";
import { map } from "rxjs/operators";

@Injectable({
  providedIn: "root"
})
export class HttpService {
  constructor(private http: HttpClient) {}

  find(
    currentPage = 1,
    pageSize = 10,
    sortOrderName: string,
    sortOrder = "asc",
    searchPropertyName: string,
    searchValue: string,
    apiUrl: string
  ): Observable<any> {
    return this.http
      .get(apiUrl, {
        params: new HttpParams()
          .set("currentPage", currentPage.toString())
          .set("pageSize", pageSize.toString())
          .set("sortOrderName", sortOrderName)
          .set("sortOrder", sortOrder)
          .set("searchPropertyName", searchPropertyName)
          .set("searchValue", searchValue)
      })
      .pipe(
        map(res => {
          return res;
        })
      );
  }
}
