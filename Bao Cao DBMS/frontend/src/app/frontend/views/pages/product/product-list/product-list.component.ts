import { Component, OnInit } from "@angular/core";

import { ProductService } from "src/app/frontend/core/services/product.service";
import { CatalogService } from "src/app/frontend/core/services/catalog.service";
import { Product } from "src/app/frontend/core/models/product.model";
import { Catalog } from "src/app/frontend/core/models/catalog.model";
import { ActivatedRoute } from "@angular/router";

@Component({
  selector: "app-product-list",
  templateUrl: "./product-list.component.html",
  styleUrls: ["./product-list.component.scss"]
})
export class ProductListComponent implements OnInit {
  products: Product[] = [];
  catalogs: Catalog[] = [];

  title: string = "Shop All";

  // OPTIONS GET LIST
  currentPage: number = 1;
  pageSize: number = 10;
  sortOrderName: string = "Id";
  sortOrder: string = "desc";
  searchValue: string = "";

  constructor(
    private activatedRoute: ActivatedRoute,
    private productService: ProductService,
    private catalogService: CatalogService
  ) {}

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      if (params["id"] != null) {
        this.title = params["catalog"];

        this.productService
          .getCatalogProductOptions(1, 10, "Id", "desc", params["id"])
          .subscribe(products => (this.products = products));
      } else {
        this.productService
          .getCatalogProductOptions(1, 10, "Id", "desc", "")
          .subscribe(products => (this.products = products));
      }
    });

    this.catalogService
      .getCatalog()
      .subscribe(catalogs => (this.catalogs = catalogs));
  }

  onSort(sortOrderName: string, sortOrder: string) {
    this.sortOrderName = sortOrderName;
    this.sortOrder = sortOrder;

    this.loadProductOptions();
  }

  loadProductOptions() {
    this.productService
      .getCatalogProductOptions(
        this.currentPage,
        this.pageSize,
        this.sortOrderName,
        this.sortOrder,
        ""
      )
      .subscribe(products => (this.products = products));
  }
}
