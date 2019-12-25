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
import { EditorModule } from "@tinymce/tinymce-angular";

//Modules
import { PartialsModule } from "../../partials/partials.module";

//Component
import { PostsListComponent } from "./posts-list/posts-list.component";
import { DialogComponent } from "../../partials/dialog/dialog.component";
import { PostEditComponent } from "./post-edit/post-edit.component";

@NgModule({
  imports: [
    CommonModule,
    ReactiveFormsModule,
    RouterModule.forChild([
      {
        path: "",
        component: PostsListComponent
      },
      {
        path: "add",
        component: PostEditComponent
      },
      {
        path: "edit/:id",
        component: PostEditComponent
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

    // Tiny Editor
    EditorModule,

    PartialsModule
  ],
  providers: [],
  entryComponents: [DialogComponent],
  declarations: [PostsListComponent, PostEditComponent]
})
export class PostsModule {}
