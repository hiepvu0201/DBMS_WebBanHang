// Angular
import { RouterModule } from "@angular/router";
import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";

// MATERIALS
import { MatDialogModule } from "@angular/material";

// Components
import { DialogComponent } from "./dialog/dialog.component";

@NgModule({
  declarations: [DialogComponent],
  imports: [CommonModule, RouterModule, FormsModule, MatDialogModule],
  exports: [DialogComponent]
})
export class PartialsModule {}
