// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";

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

// Components
import { CatalogListComponent } from "./catalog-list/catalog-list.component";
import { CatalogEditComponent } from "./catalog-edit/catalog-edit.component";
import { DialogComponent } from "../../partials/dialog/dialog.component";
import { PartialsModule } from "../../partials/partials.module";

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule.forChild([
      {
        path: "",
        component: CatalogListComponent,
        pathMatch: "full"
      },
      {
        path: "add",
        component: CatalogEditComponent
      },
      {
        path: "edit/:id",
        component: CatalogEditComponent
      }
    ]),
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
  declarations: [CatalogListComponent, CatalogEditComponent]
})
export class CatalogsModule {}
