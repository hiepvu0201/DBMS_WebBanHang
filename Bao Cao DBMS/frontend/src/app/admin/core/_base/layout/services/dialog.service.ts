import { Injectable } from "@angular/core";
import { MatDialog } from "@angular/material";
import { DialogComponent } from "src/app/admin/view/partials/dialog/dialog.component";

@Injectable({
  providedIn: "root"
})
export class DialogService {
  constructor(private dialog: MatDialog) {}

  openConfirmDialog() {
    this.dialog.open(DialogComponent, {
      width: "400px",
      disableClose: true
    });
  }
}
