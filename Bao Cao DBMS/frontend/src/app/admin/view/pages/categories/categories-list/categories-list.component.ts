import { Component, OnInit, ViewChild, ElementRef } from "@angular/core";
import { CategoriesDataSource } from "src/app/admin/core/datasource/catagories.datasource";
import { MatPaginator, MatSort, MatDialog } from "@angular/material";
import { CategoriesService } from "src/app/admin/core/services/catagories.service";
import { fromEvent, merge } from "rxjs";
import { debounceTime, distinctUntilChanged, tap } from "rxjs/operators";
import { DialogComponent } from "../../../partials/dialog/dialog.component";
import { DashboardService } from "src/app/admin/core/services/dashboard.service";

@Component({
  selector: "app-categories-list",
  templateUrl: "./categories-list.component.html",
  styleUrls: ["./categories-list.component.scss"]
})
export class CategoriesListComponent implements OnInit {
  categoriesCount: number;

  dataSource: CategoriesDataSource;
  displayedColumns = [
    "Id",
    "Name",
    "Visibility",
    "PostCount",
    "CreatedAt",
    "UpdatedAt",
    "Action"
  ];

  displayedSelects = ["Name", "ShortDescription", "Description"];

  @ViewChild(MatPaginator, { static: true }) paginator: MatPaginator;
  @ViewChild(MatSort, { static: true }) sort: MatSort;
  @ViewChild("input", { static: true }) input: ElementRef;

  constructor(
    private categoriesService: CategoriesService,
    private dashboardService: DashboardService,
    private dialog: MatDialog
  ) {}

  ngOnInit() {
    this.dataSource = new CategoriesDataSource(this.categoriesService);
    this.dataSource.loadData();

    this.dashboardService
      .getCategoryCount()
      .subscribe(res => (this.categoriesCount = res));
  }

  ngAfterViewInit() {
    // SEARCH
    fromEvent(this.input.nativeElement, "keyup")
      .pipe(
        debounceTime(150),
        distinctUntilChanged(),
        tap(() => {
          this.paginator.pageIndex = 0;
          this.loadCatalogs();
        })
      )
      .subscribe();

    // reset the paginator after sorting
    this.sort.sortChange.subscribe(() => (this.paginator.pageIndex = 0));

    // on sort or paginate events, load a new page
    merge(this.sort.sortChange, this.paginator.page)
      .pipe(tap(() => this.loadCatalogs()))
      .subscribe();
  }

  loadCatalogs() {
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
      data: { title: "Delete Product", desc: "Delete" },
      disableClose: true,
      panelClass: "custom-dialog"
    });

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.paginator.pageIndex = 0;
        this.categoriesService
          .deleteCategories(id)
          .subscribe(() => this.loadCatalogs());

        this.categoriesCount--;
      }
    });
  }
}
