import { Injectable } from "@angular/core";
import { HttpClient, HttpParams } from "@angular/common/http";
import { Observable } from "rxjs";
import { map } from "rxjs/operators";

import { Post } from "../models/post.model";

const API_URL = "https://localhost:5001/api/posts";
const API_URL_WEB = "https://localhost:5001/api/web/posts";

@Injectable({
  providedIn: "root"
})
export class PostService {
  constructor(private http: HttpClient) {}

  getPostOptions(
    currentPage = 1,
    pageSize = 10,
    sortOrderName = "Id",
    sortOrder = "desc",
    searchValue = ""
  ): Observable<Post[]> {
    return this.http
      .get<Post[]>(`${API_URL_WEB}`, {
        params: new HttpParams()
          .set("currentPage", currentPage.toString())
          .set("pageSize", pageSize.toString())
          .set("sortOrderName", sortOrderName)
          .set("sortOrder", sortOrder)
          .set("searchValue", searchValue)
      })
      .pipe(
        map(posts => {
          return posts;
        })
      );
  }

  getPost(id: number) {
    return this.http.get<Post>(`${API_URL}/${id}`);
  }
}
