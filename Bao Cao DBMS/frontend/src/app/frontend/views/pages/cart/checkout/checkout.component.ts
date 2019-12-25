import { Component, OnInit, ViewChild } from "@angular/core";
import { NgForm } from "@angular/forms";
import {
  ProductSelection,
  Cart
} from "src/app/frontend/core/models/cart.model";
import { OrderstService } from "src/app/frontend/core/services/orders.service";
import { Router } from "@angular/router";

@Component({
  selector: "app-checkout",
  templateUrl: "./checkout.component.html",
  styleUrls: ["./checkout.component.scss"]
})
export class CheckoutComponent implements OnInit {
  productSelected: ProductSelection[] = [];

  @ViewChild("form", { static: false }) checkoutForm: NgForm;

  constructor(
    private cart: Cart,
    private orderService: OrderstService,
    private router: Router
  ) {}

  ngOnInit() {
    this.productSelected = this.cart.selections;
  }

  onSubmit() {
    const productsOrder = this.cart.selections.map(s => {
      return {
        id: s.id,
        name: s.name,
        price: s.price,
        quantity: s.quantity
      };
    });

    this.orderService.addOrders(this.checkoutForm.value, productsOrder);
    this.router.navigate([""]);

    this.cart.clear();
  }
}
