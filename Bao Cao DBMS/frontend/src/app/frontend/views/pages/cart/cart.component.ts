import { Component, OnInit } from "@angular/core";
import {
  Cart,
  ProductSelection
} from "src/app/frontend/core/models/cart.model";
import { Product } from "src/app/frontend/core/models/product.model";

@Component({
  selector: "app-cart",
  templateUrl: "./cart.component.html",
  styleUrls: ["./cart.component.scss"]
})
export class CartComponent implements OnInit {
  productCartList: ProductSelection[] = [];

  constructor(private cart: Cart) {}

  ngOnInit() {
    this.productCartList = this.cart.selections;
  }

  get totalPrice(): number {
    return this.cart.totalPrice;
  }

  addQuantityProduct(product) {
    this.cart.addProduct(product);
  }

  subtractQuantityProduct(product) {
    this.cart.subtractProduct(product);
  }

  removeProduct(product) {
    this.cart.removeProduct(product);
  }
}
