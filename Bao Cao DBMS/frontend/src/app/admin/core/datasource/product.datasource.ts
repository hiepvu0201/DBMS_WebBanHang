import { CollectionViewer, DataSource } from "@angular/cdk/collections";
import { BehaviorSubject, Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";
import { ProductModel } from "../models/product.model";
import { ProductService } from "../services/product.service";

export class ProductDataSource implements DataSource<ProductModel> {
  public dataSubject = new BehaviorSubject<ProductModel[]>([]);

  constructor(private productService: ProductService) {}

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
    this.productService
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
