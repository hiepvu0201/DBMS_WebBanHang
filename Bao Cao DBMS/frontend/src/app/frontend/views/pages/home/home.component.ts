import { Component, OnInit } from "@angular/core";

import { Product } from "src/app/frontend/core/models/product.model";
import { ProductService } from "src/app/frontend/core/services/product.service";

@Component({
  selector: "app-home",
  templateUrl: "./home.component.html",
  styleUrls: ["./home.component.scss"]
})
export class HomeComponent implements OnInit {
  products: Product[] = [];

  constructor(private productService: ProductService) {}

  ngOnInit() {
    this.productService
      .getProducts()
      .subscribe(products => (this.products = products));
  }
}
