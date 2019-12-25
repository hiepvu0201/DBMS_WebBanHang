import { Injectable } from "@angular/core";
import { Product } from "./product.model";

@Injectable({
  providedIn: "root"
})
export class Cart {
  selections: ProductSelection[] = [];
  itemCount: number = 0;
  totalPrice: number = 0;

  constructor() {
    let cartLocalStorage = JSON.parse(localStorage.getItem("cart"));

    if (cartLocalStorage) {
      cartLocalStorage.map(c => {
        this.selections.push(c);
      });
    }
    this.update();
  }

  addProduct(product: Product) {
    let selection = this.selections.find(ps => ps.id === product.id);
    if (selection) {
      selection.quantity++;
    } else {
      this.selections.push(
        new ProductSelection(
          this,
          product.id,
          product.name,
          product.price,
          1,
          product.image
        )
      );
    }
    this.update();
  }

  subtractProduct(product: Product) {
    let selection = this.selections.find(ps => ps.id === product.id);
    if (selection.quantity > 1) {
      selection.quantity--;
    }
    this.update();
  }

  removeProduct(product: Product) {
    let indexSelection = this.selections.findIndex(ps => ps.id == product.id);

    this.selections.splice(indexSelection, 1);
    this.update();
  }

  updateQuantity(productId: number, quantity: number) {
    if (quantity > 0) {
      let selection = this.selections.find(ps => ps.id == productId);
      if (selection) {
        selection.quantity = quantity;
      }
    } else {
      let index = this.selections.findIndex(ps => ps.id == productId);
      if (index != -1) {
        this.selections.splice(index, 1);
      }
      this.update();
    }
  }

  clear() {
    this.selections = [];
    this.update();
  }

  update() {
    this.itemCount = this.selections
      .map(ps => ps.quantity)
      .reduce((prev, curr) => prev + curr, 0);
    this.totalPrice = this.selections
      .map(ps => ps.price * ps.quantity)
      .reduce((prev, curr) => prev + curr, 0);

    let cartLocalStorage = this.selections.map(s => {
      return {
        id: s.id,
        name: s.name,
        price: s.price,
        quantity: s.quantity,
        image: s.image
      };
    });

    localStorage.setItem("cart", JSON.stringify(cartLocalStorage));
  }

  checkProductToCart(product: Product): Boolean {
    let selection = this.selections.find(ps => ps.id == product.id);
    return selection ? true : false;
  }
}

export class ProductSelection {
  constructor(
    public cart: Cart,
    public id?: number,
    public name?: string,
    public price?: number,
    private quantityValue?: number,
    public image?: string
  ) {}

  get quantity() {
    return this.quantityValue;
  }

  set quantity(newQuantity: number) {
    this.quantityValue = newQuantity;
    this.cart.update();
  }
}
