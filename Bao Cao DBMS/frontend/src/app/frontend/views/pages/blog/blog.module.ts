// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";

// Agular Material
import { MatProgressSpinnerModule } from "@angular/material/progress-spinner";

// COMPONENTS
import { BlogListComponent } from "./blog-list/blog-list.component";
import { BlogDetailComponent } from "./blog-detail/blog-detail.component";

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild([
      {
        path: "",
        component: BlogListComponent
      },
      {
        path: ":category/:id",
        component: BlogListComponent
      },
      {
        path: ":category/:post/:id",
        component: BlogDetailComponent
      }
    ]),

    MatProgressSpinnerModule
  ],
  providers: [],
  declarations: [BlogListComponent, BlogDetailComponent]
})
export class BlogModule {}
