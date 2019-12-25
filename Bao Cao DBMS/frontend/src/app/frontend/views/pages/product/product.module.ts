// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";

// COMPONENTS
import { ProductListComponent } from "./product-list/product-list.component";
import { ProductDetailComponent } from "./product-detail/product-detail.component";

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild([
      {
        path: "",
        component: ProductListComponent
      },
      {
        path: ":catalog/:id",
        component: ProductListComponent
      },
      {
        path: ":catalog/:product/:id",
        component: ProductDetailComponent
      }
    ])
  ],
  providers: [],
  declarations: [ProductListComponent, ProductDetailComponent]
})
export class ProductModule {}
