// Angular
import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";
import { RouterModule } from "@angular/router";

// MATERIAL
import {
  MatInputModule,
  MatPaginatorModule,
  MatProgressSpinnerModule,
  MatSortModule,
  MatTableModule,
  MatSelectModule,
  MatIconModule,
  MatButtonModule,
  MatRadioModule,
  MatDialogModule
} from "@angular/material";

// COMPONENTS
import { OrdersListComponent } from "./orders-list/orders-list.component";
import { OrderDetailComponent } from "./orders-detail/orders-detail.component";

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule.forChild([
      {
        path: "",
        component: OrdersListComponent
      },
      {
        path: "detail/:id",
        component: OrderDetailComponent
      }
    ]),

    // MATERIALS
    MatInputModule,
    MatPaginatorModule,
    MatProgressSpinnerModule,
    MatSortModule,
    MatTableModule,
    MatSelectModule,
    MatIconModule,
    MatButtonModule,
    MatRadioModule,
    MatDialogModule
  ],
  entryComponents: [],
  providers: [],
  declarations: [OrdersListComponent, OrderDetailComponent]
})
export class OrdersModule {}
