import { CollectionViewer, DataSource } from "@angular/cdk/collections";
import { BehaviorSubject, Observable, of } from "rxjs";
import { catchError } from "rxjs/operators";

import { OrderModel } from "../models/order.model";
import { OrderService } from "../services/order.service";

export class OrderDataSource implements DataSource<OrderModel> {
  public dataSubject = new BehaviorSubject<OrderModel[]>([]);

  constructor(private orderSevice: OrderService) {}

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
    this.orderSevice
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
