// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";
import { ReactiveFormsModule } from "@angular/forms";

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

// CKEditor
import { CKEditorModule } from "@ckeditor/ckeditor5-angular";
import { EditorModule } from "@tinymce/tinymce-angular";

//Modules
import { PartialsModule } from "../../partials/partials.module";

// Component
import { ProductsListComponent } from "./products-list/products-list.component";
import { ProductEditComponent } from "./product-edit/product-edit.component";
import { DialogComponent } from "../../partials/dialog/dialog.component";

@NgModule({
  imports: [
    CommonModule,
    ReactiveFormsModule,
    RouterModule.forChild([
      {
        path: "",
        component: ProductsListComponent
      },
      {
        path: "add",
        component: ProductEditComponent
      },
      {
        path: "edit/:id",
        component: ProductEditComponent
      }
    ]),

    // Materials
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

    // CKEditor
    CKEditorModule,
    EditorModule,

    PartialsModule
  ],
  providers: [],
  entryComponents: [DialogComponent],
  declarations: [ProductsListComponent, ProductEditComponent]
})
export class ProductsModule {}
