import { Component, OnInit } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { CatalogsModel } from "src/app/admin/core/models/catalogs.model";
import { CatalogsService } from "src/app/admin/core/services/catalogs.service";
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Location } from "@angular/common";

import { ProductService } from "src/app/admin/core/services/product.service";
import { ProductModel } from "src/app/admin/core/models/product.model";

@Component({
  selector: "app-product-edit",
  templateUrl: "./product-edit.component.html",
  styleUrls: ["./product-edit.component.scss"]
})
export class ProductEditComponent implements OnInit {
  id: number;

  title: string = "Add";
  productOld: ProductModel = new ProductModel();
  productNew: CatalogsModel;

  fileImage: File;
  listCatalogs: any;
  form: FormGroup;
  selectedValueCatalog = "";
  imagePreview: string;

  constructor(
    private productService: ProductService,
    private catalogService: CatalogsService,
    private activatedRoute: ActivatedRoute,
    private location: Location
  ) {}

  ngOnInit() {
    // FORM
    this.form = new FormGroup({
      name: new FormControl(null, {
        validators: [Validators.required]
      }),
      shortDescription: new FormControl(null, {
        validators: [Validators.required]
      }),
      price: new FormControl(null, {
        validators: [Validators.required]
      }),
      image: new FormControl(null),
      description: new FormControl(null, {
        validators: [Validators.required]
      }),
      catalogId: new FormControl(null),
      visibility: new FormControl(null)
    });

    // GET ID URL
    this.activatedRoute.params.subscribe(params => {
      if (params["id"] != null) {
        this.id = params["id"];
        this.title = "Edit";

        // GET PRODUCT USE ID
        this.productService.getProduct(params["id"]).subscribe(res => {
          this.productOld = res;

          // SET VALUES FORM
          this.form.setValue({
            name: this.productOld.name,
            shortDescription: this.productOld.shortDescription,
            price: this.productOld.price,
            image: this.productOld.image,
            description: this.productOld.description,
            catalogId: this.productOld.catalog.name,
            visibility: this.productOld.visibility
          });

          this.selectedValueCatalog = this.productOld.catalog.name;
        });
      }
    });

    // LOAD LIST CATALOGS
    this.catalogService
      .findAllOtions()
      .subscribe(res => (this.listCatalogs = res));
  }

  onUploadImage(event: Event) {
    const file = (event.target as HTMLInputElement).files[0];
    this.form.patchValue({ image: file });
    this.form.get("image").updateValueAndValidity();

    // Image Preview
    const reader = new FileReader();
    reader.onload = () => {
      this.imagePreview = reader.result as string;
    };
    reader.readAsDataURL(file);
  }

  onSubmit() {
    // GET catalogId use catalogName
    const catalogId = this.listCatalogs.find(
      catalog => catalog.name == this.selectedValueCatalog
    ).id;

    this.form.patchValue({ catalogId: catalogId });
    this.form.get("catalogId").updateValueAndValidity();

    if (this.title === "Edit") {
      return this.productService
        .editProduct(this.id, this.form.value)
        .subscribe(() => this.goBack());
    }

    return this.productService
      .addProduct(this.form.value)
      .subscribe(() => this.goBack());
  }

  goBack() {
    this.location.back();
  }
}
