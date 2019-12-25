import { CollectionViewer, DataSource } from "@angular/cdk/collections";
import { BehaviorSubject, Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { CatalogsService } from "../services/catalogs.service";
import { CatalogsModel } from "../models/catalogs.model";

export class DataSourcceCatalogs implements DataSource<CatalogsModel> {
  public dataSubject = new BehaviorSubject<CatalogsModel[]>([]);

  constructor(private catalogsService: CatalogsService) {}

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
    this.catalogsService
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
