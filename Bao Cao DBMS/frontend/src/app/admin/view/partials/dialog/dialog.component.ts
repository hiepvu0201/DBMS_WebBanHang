import { Component } from "@angular/core";
import { MatDialogRef } from "@angular/material";

@Component({
  selector: "p-dialog",
  templateUrl: "./dialog.component.html",
  styleUrls: ["./dialog.component.scss"]
})
export class DialogComponent {
  constructor(private dialogRef: MatDialogRef<DialogComponent>) {}

  onNoClick(): void {
    this.dialogRef.close();
  }

  /**
   * Close dialog with true result
   */
  onYesClick(): void {
    this.dialogRef.close(true);
  }
}
