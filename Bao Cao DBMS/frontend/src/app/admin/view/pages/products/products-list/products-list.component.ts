import { Component, OnInit, ViewChild, ElementRef } from "@angular/core";
import { ProductDataSource } from "src/app/admin/core/datasource/product.datasource";
import { MatPaginator, MatSort, MatDialog } from "@angular/material";
import { ProductService } from "src/app/admin/core/services/product.service";
import { fromEvent, merge } from "rxjs";
import { debounceTime, distinctUntilChanged, tap } from "rxjs/operators";
import { DialogComponent } from "../../../partials/dialog/dialog.component";
import { DashboardService } from "src/app/admin/core/services/dashboard.service";

@Component({
  selector: "app-products-list",
  templateUrl: "./products-list.component.html",
  styleUrls: ["./products-list.component.scss"]
})
export class ProductsListComponent implements OnInit {
  dataSource: ProductDataSource;
  displayedColumns = [
    "Id",
    "Name",
    "Price",
    "Image",
    "Visibility",
    "Catalog",
    "CreatedAt",
    "UpdatedAt",
    "Action"
  ];

  displayedSelects = ["Name"];
  productCount: number;

  @ViewChild(MatPaginator, { static: true }) paginator: MatPaginator;
  @ViewChild(MatSort, { static: true }) sort: MatSort;
  @ViewChild("input", { static: true }) input: ElementRef;

  constructor(
    private productService: ProductService,
    private dashboardService: DashboardService,
    private dialog: MatDialog
  ) {}

  ngOnInit() {
    this.dataSource = new ProductDataSource(this.productService);
    this.dataSource.loadData();

    this.dashboardService
      .getProductCount()
      .subscribe(res => (this.productCount = res));
  }

  ngAfterViewInit() {
    // SEARCH
    fromEvent(this.input.nativeElement, "keyup")
      .pipe(
        debounceTime(150),
        distinctUntilChanged(),
        tap(() => {
          this.paginator.pageIndex = 0;
          this.loadProducts();
        })
      )
      .subscribe();

    // reset the paginator after sorting
    this.sort.sortChange.subscribe(() => (this.paginator.pageIndex = 0));

    // on sort or paginate events, load a new page
    merge(this.sort.sortChange, this.paginator.page)
      .pipe(tap(() => this.loadProducts()))
      .subscribe();
  }

  loadProducts() {
    this.dataSource.loadData(
      this.paginator.pageIndex + 1,
      this.paginator.pageSize,
      this.sort.active,
      this.sort.direction,
      this.input.nativeElement.value
    );
  }

  onDelete(id) {
    const dialogRef = this.dialog.open(DialogComponent, {
      width: "400px",
      disableClose: true
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.paginator.pageIndex = 0;
        this.productService
          .deleteProduct(id)
          .subscribe(() => this.loadProducts());

        this.productCount--;
      }
    });
  }
}
