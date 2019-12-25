// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";

// COMPONENTS
import { CartComponent } from "./cart.component";
import { CheckoutComponent } from "./checkout/checkout.component";
import { FormsModule } from "@angular/forms";

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild([
      {
        path: "",
        component: CartComponent
      },
      {
        path: "checkout",
        component: CheckoutComponent
      }
    ]),
    FormsModule
  ],
  providers: [],
  declarations: [CartComponent, CheckoutComponent]
})
export class CartModule {}
