import { Component, OnInit } from "@angular/core";
import { ActivatedRoute } from "@angular/router";

import { CategoryService } from "src/app/frontend/core/services/category.service";
import { PostService } from "src/app/frontend/core/services/post.service";
import { Category } from "src/app/frontend/core/models/category.model";
import { Post } from "src/app/frontend/core/models/post.model";

@Component({
  selector: "app-blog-list",
  templateUrl: "./blog-list.component.html",
  styleUrls: ["./blog-list.component.scss"]
})
export class BlogListComponent implements OnInit {
  categories: Category[] = [];
  posts: Post[] = [];

  title: string = "Shop All";

  // OPTIONS GET LIST
  currentPage: number = 1;
  pageSize: number = 4;
  sortOrderName: string = "Id";
  sortOrder: string = "desc";
  searchValue: string = "";

  constructor(
    private activatedRoute: ActivatedRoute,
    private postService: PostService,
    private categoryService: CategoryService
  ) {}

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      if (params["id"] != null) {
        this.title = params["catalog"];

        this.postService
          .getPostOptions(1, 4, "Id", "desc", params["id"])
          .subscribe(posts => (this.posts = posts));
      } else {
        this.postService
          .getPostOptions(1, 4, "Id", "desc", "")
          .subscribe(posts => (this.posts = posts));
      }
    });

    this.categoryService
      .getCategories()
      .subscribe(categories => (this.categories = categories));
  }

  onSort(sortOrderName: string, sortOrder: string) {
    this.sortOrderName = sortOrderName;
    this.sortOrder = sortOrder;

    this.loadPostOptions();
  }

  loadPostOptions() {
    this.postService
      .getPostOptions(
        this.currentPage,
        this.pageSize,
        this.sortOrderName,
        this.sortOrder,
        ""
      )
      .subscribe(posts => (this.posts = posts));
  }
}
