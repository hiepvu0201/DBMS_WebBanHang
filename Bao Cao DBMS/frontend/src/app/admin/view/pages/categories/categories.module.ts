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

// MODULES
import { PartialsModule } from "../../partials/partials.module";

// COMPONENTS
import { CategoriesListComponent } from "./categories-list/categories-list.component";
import { DialogComponent } from "../../partials/dialog/dialog.component";
import { CategoriesEditComponent } from "./categories-edit/categories-edit.component";

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule.forChild([
      {
        path: "",
        component: CategoriesListComponent
      },
      {
        path: "add",
        component: CategoriesEditComponent
      },
      {
        path: "edit/:id",
        component: CategoriesEditComponent
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
    MatDialogModule,

    PartialsModule
  ],
  entryComponents: [DialogComponent],
  providers: [],
  declarations: [CategoriesListComponent, CategoriesEditComponent]
})
export class CategoriesModule {}
