import { Component, OnInit } from "@angular/core";
import { ActivatedRoute } from "@angular/router";
import { CatalogsModel } from "src/app/admin/core/models/catalogs.model";
import { FormGroup, FormControl, Validators } from "@angular/forms";
import { Location } from "@angular/common";

import { PostService } from "src/app/admin/core/services/post.service";
import { CategoriesService } from "src/app/admin/core/services/catagories.service";
import { PostModel } from "src/app/admin/core/models/post.model";

@Component({
  selector: "app-post-edit",
  templateUrl: "./post-edit.component.html",
  styleUrls: ["./post-edit.component.scss"]
})
export class PostEditComponent implements OnInit {
  id: number;

  title: string = "Add";
  postOld: PostModel = new PostModel();
  postNew: CatalogsModel;

  fileImage: File;
  listcategories: any;
  form: FormGroup;
  selectedValueCategory = "";
  imagePreview: string;

  constructor(
    private postService: PostService,
    private categoriesService: CategoriesService,
    private activatedRoute: ActivatedRoute,
    private location: Location
  ) {}

  ngOnInit() {
    // FORM
    this.form = new FormGroup({
      title: new FormControl(null, {
        validators: [Validators.required]
      }),
      shortDescription: new FormControl(null, {
        validators: [Validators.required]
      }),
      image: new FormControl(null),
      content: new FormControl(null, {
        validators: [Validators.required]
      }),
      categoryId: new FormControl(null),
      visibility: new FormControl(null, {
        validators: [Validators.required]
      })
    });

    // GET ID URL
    this.activatedRoute.params.subscribe(params => {
      if (params["id"] != null) {
        this.id = params["id"];
        this.title = "Edit";

        // GET PRODUCT USE ID
        this.postService.getPost(params["id"]).subscribe(res => {
          this.postOld = res;

          // SET VALUES FORM
          this.form.setValue({
            title: this.postOld.title,
            shortDescription: this.postOld.shortDescription,
            content: this.postOld.content,
            categoryId: this.postOld.categoryId,
            image: null,
            visibility: this.postOld.visibility
          });

          this.selectedValueCategory = this.postOld.category.name;
        });
      }
    });

    // LOAD LIST CATALOGS
    this.categoriesService
      .findAllOtions()
      .subscribe(res => (this.listcategories = res));
  }

  onUploadImage(event: Event) {
    const file = (event.target as HTMLInputElement).files[0];
    this.form.patchValue({ image: file });
    this.form.get("image").updateValueAndValidity();

    // Image Priview
    const reader = new FileReader();
    reader.onload = () => {
      this.imagePreview = reader.result as string;
    };
    reader.readAsDataURL(file);
  }

  onSubmit() {
    if (this.title === "Edit") {
      return this.postService
        .editPost(this.id, this.form.value)
        .subscribe(() => this.goBack());
    }

    console.log(this.form.value);

    return this.postService
      .addPost(this.form.value)
      .subscribe(() => this.goBack());
  }

  goBack() {
    this.location.back();
  }
}
