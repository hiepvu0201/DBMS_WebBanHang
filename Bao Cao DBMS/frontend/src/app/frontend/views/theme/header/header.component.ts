import { Component, OnInit } from "@angular/core";
import { Cart } from "src/app/frontend/core/models/cart.model";

@Component({
  selector: "app-header",
  templateUrl: "./header.component.html",
  styleUrls: ["./header.component.scss"]
})
export class HeaderComponent implements OnInit {
  constructor(private cart: Cart) {}

  ngOnInit() {}

  get itemCartCount(): number {
    return this.cart.itemCount;
  }
}
