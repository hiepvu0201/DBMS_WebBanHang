import { Component, OnInit } from "@angular/core";
import { ActivatedRoute, Params } from "@angular/router";
import { PostService } from "src/app/frontend/core/services/post.service";
import { Post } from "src/app/frontend/core/models/post.model";
import { CategoryService } from "src/app/frontend/core/services/category.service";
import { Category } from "src/app/frontend/core/models/category.model";

@Component({
  selector: "app-blog-detail",
  templateUrl: "./blog-detail.component.html",
  styleUrls: ["./blog-detail.component.scss"]
})
export class BlogDetailComponent implements OnInit {
  id: number;
  post: Post;
  isLoading: boolean = true;

  categories: Category[] = [];

  constructor(
    private router: ActivatedRoute,
    private postService: PostService,
    private categoryService: CategoryService
  ) {}

  ngOnInit() {
    this.router.params.subscribe((params: Params) => {
      this.id = +params["id"];
      this.postService.getPost(this.id).subscribe(p => {
        this.post = p;

        this.isLoading = false;
      });
    });

    this.categoryService
      .getCategories()
      .subscribe(categories => (this.categories = categories));
  }
}
