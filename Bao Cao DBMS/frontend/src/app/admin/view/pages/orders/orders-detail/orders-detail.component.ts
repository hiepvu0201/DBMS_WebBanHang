import { Component, OnInit } from "@angular/core";
import { OrderService } from "src/app/admin/core/services/order.service";
import { BillModel } from "src/app/admin/core/models/bill.model";
import { ActivatedRoute } from "@angular/router";

@Component({
  selector: "app-orders-detail",
  templateUrl: "orders-detail.component.html",
  styleUrls: ["orders-detail.component.scss"]
})
export class OrderDetailComponent implements OnInit {
  bills: any;
  totalPrice: number = 0;

  constructor(
    private orderService: OrderService,
    private activatedRoute: ActivatedRoute
  ) {}

  ngOnInit() {
    this.activatedRoute.params.subscribe(params => {
      if (params["id"] != null) {
        this.orderService.getDetail(params["id"]).subscribe(res => {
          this.bills = res;

          for (let i = 0; i < this.bills.length; i++) {
            this.totalPrice += this.bills[i].price * this.bills[i].quantity;
          }
        });
      }
    });
  }
}
