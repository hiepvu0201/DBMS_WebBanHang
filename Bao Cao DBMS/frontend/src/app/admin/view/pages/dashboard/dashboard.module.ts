// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";

import { MatIconModule } from "@angular/material";

// Core Module
import { DashboardComponent } from "./dashboard.component";

@NgModule({
  imports: [
    CommonModule,
    RouterModule.forChild([
      {
        path: "",
        component: DashboardComponent
      }
    ]),

    MatIconModule
  ],
  providers: [],
  declarations: [DashboardComponent]
})
export class DashboardModule {}
