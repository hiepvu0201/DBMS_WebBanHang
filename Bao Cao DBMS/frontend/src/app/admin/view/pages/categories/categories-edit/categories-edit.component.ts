import { Component, ViewChild } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { NgForm } from "@angular/forms";
import { Location } from "@angular/common";

import { CategorieModel } from "src/app/admin/core/models/categories.mode";
import { CategoriesService } from "src/app/admin/core/services/catagories.service";

@Component({
  selector: "app-catalog-edit",
  templateUrl: "./categories-edit.component.html",
  styleUrls: ["./categories-edit.component.scss"]
})
export class CategoriesEditComponent {
  title: string = "Add";
  catalogOld: CategorieModel = new CategorieModel();
  catalogNew: CategorieModel;

  @ViewChild("form", { static: false }) signupForm: NgForm;

  constructor(
    private categoriesService: CategoriesService,
    private activatedRoute: ActivatedRoute,
    private location: Location
  ) {
    this.activatedRoute.params.subscribe(params => {
      if (params["id"] != null) {
        this.title = "Edit";
        this.loadCategoriesById(params["id"]);
        console.log(params["id"]);
      }
    });
  }

  loadCategoriesById(id) {
    this.categoriesService.getCategories(id).subscribe(res => {
      this.catalogOld = res;
    });
  }

  onSubmit() {
    if (this.title === "Edit") {
      return this.categoriesService
        .updataCategories(this.catalogOld.id, this.signupForm.value)
        .subscribe(() => this.goBack());
    }
    return this.categoriesService
      .addCategories(this.signupForm.value)
      .subscribe(() => this.goBack());
  }

  goBack() {
    this.location.back();
  }
}
