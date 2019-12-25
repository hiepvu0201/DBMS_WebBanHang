import { Component, OnInit } from "@angular/core";
import { SidebarService } from "src/app/admin/core/_base/layout/services/sidebar.service";
import { AuthService } from "src/app/admin/core/services/auth.service";

@Component({
  selector: "app-header",
  templateUrl: "./header.component.html",
  styleUrls: ["./header.component.scss"]
})
export class HeaderComponent implements OnInit {
  isToggleMenu: boolean = true;

  constructor(
    private sidebarService: SidebarService,
    private authService: AuthService
  ) {}
  ngOnInit() {
    this.sidebarService.isMenuOpenChanged.subscribe(
      res => (this.isToggleMenu = res)
    );
  }

  onToggleSidebar() {
    this.sidebarService.toggleSidebar();
  }

  logout() {
    this.authService.logout();
  }
}
