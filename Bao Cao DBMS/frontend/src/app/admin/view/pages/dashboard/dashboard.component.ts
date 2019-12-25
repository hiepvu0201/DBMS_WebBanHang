import { Component, OnInit } from "@angular/core";
import { DashboardService } from "src/app/admin/core/services/dashboard.service";

@Component({
  selector: "app-dashboard",
  templateUrl: "./dashboard.component.html",
  styleUrls: ["./dashboard.component.scss"]
})
export class DashboardComponent implements OnInit {
  totalCatalogs: number;
  totalProducts: number;
  totalCategories: number;
  totalPosts: number;
  totalOrders: number;
  totalPrice: number;

  constructor(private dashboardService: DashboardService) {}

  ngOnInit() {
    this.dashboardService.getCatalogCount().subscribe(res => {
      this.totalCatalogs = res;
    });

    this.dashboardService.getProductCount().subscribe(res => {
      this.totalProducts = res;
    });

    this.dashboardService.getCategoryCount().subscribe(res => {
      this.totalCategories = res;
    });

    this.dashboardService.getPostCount().subscribe(res => {
      this.totalPosts = res;
    });

    this.dashboardService.getOrderCount().subscribe(res => {
      this.totalOrders = res;
    });

    this.dashboardService.getTotalPrice().subscribe(res => {
      this.totalPrice = res;
    });
  }
}
