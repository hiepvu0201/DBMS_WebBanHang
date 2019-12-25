import { Component, OnInit } from "@angular/core";
import { SidebarService } from "src/app/admin/core/_base/layout/services/sidebar.service";

@Component({
  selector: "app-sidebar",
  templateUrl: "./sidebar.component.html",
  styleUrls: ["./sidebar.component.scss"]
})
export class SidebarComponent implements OnInit {
  isMenuOpen: boolean = true;
  constructor(private sidebarService: SidebarService) {}

  ngOnInit() {
    this.sidebarService.isMenuOpenChanged.subscribe(
      res => (this.isMenuOpen = res)
    );
  }
}
