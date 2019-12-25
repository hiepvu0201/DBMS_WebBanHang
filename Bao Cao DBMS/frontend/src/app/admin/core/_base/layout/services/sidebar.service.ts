import { Injectable, EventEmitter } from "@angular/core";

@Injectable({
  providedIn: "root"
})
export class SidebarService {
  private isMenuOpen: boolean = true;
  public isMenuOpenChanged = new EventEmitter<boolean>();
  toggleSidebar() {
    this.isMenuOpen = !this.isMenuOpen;
    this.isMenuOpenChanged.emit(this.isMenuOpen);
  }
}
