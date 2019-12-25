import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { BaseComponent } from "./views/theme/base/base.component";

// const routes: Routes = [
//   { path: "", component: HomeComponent },
//   { path: "home", component: HomeComponent },
//   { path: "products", component: ProductListComponent },
//   { path: "product/:id", component: ProductDetailComponent },
//   { path: "cart", component: CartComponent },
//   { path: "cart/checkout", component: CheckoutComponent },
//   { path: "blog", component: BlogListComponent },
//   { path: "blog/:id", component: BlogDetailComponent },
//   { path: "about", component: AboutComponent }
// ];

const routes: Routes = [
  {
    path: "",
    component: BaseComponent,
    children: [
      {
        path: "",
        loadChildren: () =>
          import("./views/pages/home/home.module").then(m => m.HomeModule)
      },
      {
        path: "home",
        loadChildren: () =>
          import("./views/pages/home/home.module").then(m => m.HomeModule)
      },
      {
        path: "cart",
        loadChildren: () =>
          import("./views/pages/cart/cart.module").then(m => m.CartModule)
      },
      {
        path: "products",
        loadChildren: () =>
          import("./views/pages/product/product.module").then(
            m => m.ProductModule
          )
      },
      {
        path: "product",
        loadChildren: () =>
          import("./views/pages/product/product.module").then(
            m => m.ProductModule
          )
      },
      {
        path: "blog",
        loadChildren: () =>
          import("./views/pages/blog/blog.module").then(m => m.BlogModule)
      },
      {
        path: "about",
        loadChildren: () =>
          import("./views/pages/about/about.module").then(m => m.AboutModule)
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class FrontEndRoutingModule {}
