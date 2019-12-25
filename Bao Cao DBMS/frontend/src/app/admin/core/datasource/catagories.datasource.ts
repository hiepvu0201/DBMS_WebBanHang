import { CollectionViewer, DataSource } from "@angular/cdk/collections";
import { BehaviorSubject, Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";

import { CategorieModel } from "../models/categories.mode";
import { CategoriesService } from "../services/catagories.service";

export class CategoriesDataSource implements DataSource<CategorieModel> {
  public dataSubject = new BehaviorSubject<CategorieModel[]>([]);

  constructor(private categoriesService: CategoriesService) {}

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
    this.categoriesService
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
