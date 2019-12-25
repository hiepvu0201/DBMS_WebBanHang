import { CollectionViewer, DataSource } from "@angular/cdk/collections";
import { BehaviorSubject, Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";

import { PostModel } from "../models/post.model";
import { PostService } from "../services/post.service";

export class PostDataSource implements DataSource<PostModel> {
  public dataSubject = new BehaviorSubject<PostModel[]>([]);

  constructor(private postService: PostService) {}

  connect(collectionViewer: CollectionViewer): Observable<any[]> {
    return this.dataSubject.asObservable();
  }

  disconnect(collectionViewer: CollectionViewer): void {
    this.dataSubject.complete();
  }

  loadData(
    currentPage = 1,
    pageSize = 3,
    sortOrderName = "Id",
    sortOrder = "asc",
    searchValue = ""
  ) {
    this.postService
      .findAllOtions(
        currentPage,
        pageSize,
        sortOrderName,
        sortOrder,
        searchValue
      )
      .pipe(catchError(() => of([])))
      .subscribe(data => {
        this.dataSubject.next(data);
      });
  }
}
