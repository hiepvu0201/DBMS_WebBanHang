import { CollectionViewer, DataSource } from "@angular/cdk/collections";
import { BehaviorSubject, Observable, of } from "rxjs";
import { HttpService } from "./http.service";
import { catchError } from "rxjs/operators";

export class BaseDataSource<T> implements DataSource<T> {
  public dataSubject = new BehaviorSubject<any[]>([]);

  constructor(private httpService: HttpService) {}

  connect(collectionViewer: CollectionViewer): Observable<any[]> {
    return this.dataSubject.asObservable();
  }

  disconnect(collectionViewer: CollectionViewer): void {
    this.dataSubject.complete();
  }

  loadData(
    currentPage: number,
    pageSize: number,
    sortOrderName: string,
    sortOrder: string,
    searchPropertyName: string,
    searchValue: string,
    apiUrl: string
  ) {
    this.httpService
      .find(
        currentPage,
        pageSize,
        sortOrderName,
        sortOrder,
        searchPropertyName,
        searchValue,
        apiUrl
      )
      .pipe(catchError(() => of([])))
      .subscribe(data => {
        this.dataSubject.next(data);
      });
  }
}
