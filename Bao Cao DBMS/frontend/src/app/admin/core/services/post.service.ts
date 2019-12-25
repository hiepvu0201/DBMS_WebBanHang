import { Injectable } from "@angular/core";
import { Observable } from "rxjs";
import { HttpClient, HttpParams } from "@angular/common/http";
import { map } from "rxjs/operators";
import { PostModel } from "../models/post.model";

const API_URL = "https://localhost:5001/api/posts";

@Injectable({
  providedIn: "root"
})
export class PostService {
  constructor(private http: HttpClient) {}

  findAllOtions(
    currentPage = 1,
    pageSize = 10,
    sortOrderName = "Id",
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

  getPost(id) {
    return this.http.get<PostModel>(`${API_URL}/${id}`);
  }

  getPostsCount() {
    return this.http.get<number>(`${API_URL}/count`);
  }

  addPost(data) {
    const postData = new FormData();
    postData.append("title", data.title);
    postData.append("shortDescription", data.shortDescription);
    postData.append("content", data.content);
    postData.append("file", data.image);
    postData.append("categoryId", data.categoryId);
    postData.append("visibility", data.visibility);

    return this.http.post<PostModel>(API_URL, postData);
  }

  editPost(id, data) {
    const postData = new FormData();
    postData.append("title", data.title);
    postData.append("shortDescription", data.shortDescription);
    postData.append("content", data.content);
    postData.append("categoryId", data.categoryId);
    postData.append("visibility", data.visibility);

    if (data.image) {
      postData.append("file", data.image);
    }

    console.log(data);
    return this.http.put<PostModel>(`${API_URL}/${id}`, postData);
  }

  deletePost(id) {
    return this.http.delete(`${API_URL}/${id}`);
  }
}
