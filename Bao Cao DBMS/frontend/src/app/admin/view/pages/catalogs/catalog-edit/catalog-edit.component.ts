import { Component, ViewChild } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { CatalogsModel } from "src/app/admin/core/models/catalogs.model";
import { CatalogsService } from "src/app/admin/core/services/catalogs.service";
import { NgForm } from "@angular/forms";
import { Location } from "@angular/common";

@Component({
  selector: "app-catalog-edit",
  templateUrl: "./catalog-edit.component.html",
  styleUrls: ["./catalog-edit.component.scss"]
})
export class CatalogEditComponent {
  title: string = "Add";
  catalogOld: CatalogsModel = new CatalogsModel();
  catalogNew: CatalogsModel;

  @ViewChild("form", { static: false }) signupForm: NgForm;

  constructor(
    private catalogsService: CatalogsService,
    private activatedRoute: ActivatedRoute,
    private location: Location
  ) {
    this.activatedRoute.params.subscribe(params => {
      if (params["id"] != null) {
        this.title = "Edit";
        this.loadCatalogById(params["id"]);
      }
    });
  }

  loadCatalogById(id) {
    this.catalogsService.findCatalogById(id).subscribe(res => {
      this.catalogOld = res;
    });
  }

  onSubmit() {
    if (this.title === "Edit") {
      return this.catalogsService
        .updataCatalog(this.catalogOld.id, this.signupForm.value)
        .subscribe(() => this.goBack());
    }
    return this.catalogsService
      .addCatalog(this.signupForm.value)
      .subscribe(() => this.goBack());
  }

  goBack() {
    this.location.back();
  }
}
