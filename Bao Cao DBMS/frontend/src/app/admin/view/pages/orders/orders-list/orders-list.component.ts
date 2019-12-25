import { Component, ViewChild, ElementRef } from "@angular/core";
import { MatPaginator, MatSort } from "@angular/material";
import { fromEvent, merge } from "rxjs";
import { debounceTime, distinctUntilChanged, tap } from "rxjs/operators";

import { OrderDataSource } from "src/app/admin/core/datasource/order.datasource";
import { OrderService } from "src/app/admin/core/services/order.service";
import { DashboardService } from "src/app/admin/core/services/dashboard.service";

@Component({
  selector: "app-orders-list",
  templateUrl: "./orders-list.component.html"
})
export class OrdersListComponent {
  ordersCount: number;

  dataSource: OrderDataSource;
  displayedColumns = [
    "Id",
    "First Name",
    "Last Name",
    "Phone",
    "Email",
    "Address",
    "City",
    "Action"
  ];

  @ViewChild(MatPaginator, { static: true }) paginator: MatPaginator;
  @ViewChild(MatSort, { static: true }) sort: MatSort;
  @ViewChild("input", { static: true }) input: ElementRef;

  constructor(
    private orderService: OrderService,
    private dashboardService: DashboardService
  ) {}

  ngOnInit() {
    this.dataSource = new OrderDataSource(this.orderService);
    this.dataSource.loadData();

    this.dashboardService
      .getOrderCount()
      .subscribe(res => (this.ordersCount = res));
  }

  ngAfterViewInit() {
    // SEARCH
    fromEvent(this.input.nativeElement, "keyup")
      .pipe(
        debounceTime(150),
        distinctUntilChanged(),
        tap(() => {
          this.paginator.pageIndex = 0;
          this.loadOrders();
        })
      )
      .subscribe();

    // reset the paginator after sorting
    this.sort.sortChange.subscribe(() => (this.paginator.pageIndex = 0));

    // on sort or paginate events, load a new page
    merge(this.sort.sortChange, this.paginator.page)
      .pipe(tap(() => this.loadOrders()))
      .subscribe();
  }

  loadOrders() {
    this.dataSource.loadData(
      this.paginator.pageIndex + 1,
      this.paginator.pageSize,
      this.sort.active,
      this.sort.direction,
      this.input.nativeElement.value
    );
  }
}
