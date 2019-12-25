// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";

// Core Module
import { HomeComponent } from "./home.component";
import { CarouselComponent } from "../carousel/carousel.component";

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild([
      {
        path: "",
        component: HomeComponent
      }
    ])
  ],
  providers: [],
  declarations: [HomeComponent, CarouselComponent]
})
export class HomeModule {}
