// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";

// COMPONENTS
import { AboutComponent } from "./about.component";

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild([
      {
        path: "",
        component: AboutComponent
      }
    ])
  ],
  providers: [],
  declarations: [AboutComponent]
})
export class AboutModule {}
