import { Component, ViewChild, OnInit } from "@angular/core";
import { NgForm } from "@angular/forms";

import { AuthService } from "src/app/admin/core/services/auth.service";

@Component({
  templateUrl: "auth.component.html",
  styleUrls: ["auth.component.scss"]
})
export class AuthComponent {
  @ViewChild("form", { static: false }) signupForm: NgForm;

  title: string = "Login";

  showError: boolean = false;

  flag: boolean = false;

  constructor(public authService: AuthService) {}

  onClickFlag() {
    this.title = this.title === "Register" ? "Login" : "Register";
    this.flag = !this.flag;
  }

  onLogin() {
    this.showError = false;
    this.authService.login(this.signupForm.value).subscribe(result => {
      this.showError = !result;
    });
  }

  onRegister() {
    this.showError = false;
    this.authService.register(this.signupForm.value).subscribe(result => {
      this.showError = !result;
    });
  }
}
