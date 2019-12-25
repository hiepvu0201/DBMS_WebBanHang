import { NgModule } from "@angular/core";
import { CommonModule } from "@angular/common";
import { RouterModule } from "@angular/router";

// COMPONENTS
import { BaseComponent } from "./base/base.component";
import { HeaderComponent } from "./header/header.component";
import { FooterComponent } from "./footer/footer.component";

@NgModule({
  declarations: [BaseComponent, HeaderComponent, FooterComponent],
  imports: [CommonModule, RouterModule],
  exports: []
})
export class ThemeModule {}
