import { BrowserModule } from "@angular/platform-browser";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { HttpClientModule, HTTP_INTERCEPTORS } from "@angular/common/http";

import { AdminRoutingModule } from "./admin-routing.module";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";

// MODULE
import { ThemeModule } from "./view/theme/theme.module";
import { PartialsModule } from "./view/partials/partials.module";
import { PagesModule } from "./view/pages/pages.module";
import { JwtInterceptor } from "./core/helpers/jwt.interceptor";

@NgModule({
  declarations: [],
  imports: [ThemeModule, PagesModule],

  exports: [ThemeModule, PagesModule]
})
export class AdminModule {}
