import { Component, OnInit } from "@angular/core";
import { ActivatedRoute, Params } from "@angular/router";
import { Product } from "src/app/frontend/core/models/product.model";
import { ProductService } from "src/app/frontend/core/services/product.service";
import { Cart } from "src/app/frontend/core/models/cart.model";

@Component({
  selector: "app-product-detail",
  templateUrl: "./product-detail.component.html",
  styleUrls: ["./product-detail.component.scss"]
})
export class ProductDetailComponent implements OnInit {
  id: number;
  product: Product = null;

  isAddToCart: boolean = true;

  constructor(
    private router: ActivatedRoute,
    private productService: ProductService,
    private cart: Cart
  ) {}

  ngOnInit() {
    this.router.params.subscribe((params: Params) => {
      this.id = +params["id"];
      this.productService.getProduct(this.id).subscribe(p => {
        this.product = p;

        this.isAddToCart = this.cart.checkProductToCart(this.product)
          ? false
          : true;
      });
    });
  }

  addToCart(product: Product) {
    this.cart.addProduct(product);
    this.isAddToCart = false;
  }

  removeToCart(product: Product) {
    this.cart.removeProduct(product);
    this.isAddToCart = true;
  }
}
