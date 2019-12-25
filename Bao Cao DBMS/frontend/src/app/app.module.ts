import { BrowserModule } from "@angular/platform-browser";
import { NgModule } from "@angular/core";
import { FormsModule } from "@angular/forms";
import { HttpClientModule, HTTP_INTERCEPTORS } from "@angular/common/http";

import { AdminRoutingModule } from "./admin/admin-routing.module";
import { AppComponent } from "./app.component";
import { BrowserAnimationsModule } from "@angular/platform-browser/animations";

// MODULE
import { ThemeModule } from "./admin/view/theme/theme.module";
import { PartialsModule } from "./admin/view/partials/partials.module";
import { PagesModule } from "./admin/view/pages/pages.module";
import { JwtInterceptor } from "./admin/core/helpers/jwt.interceptor";
import { AdminModule } from "./admin/admin.module";
import { FrontEndRoutingModule } from "./frontend/frontend-routing.module";
import { FrontEndModule } from "./frontend/frontend.module";

@NgModule({
  declarations: [AppComponent],
  imports: [
    BrowserModule,

    AdminRoutingModule,
    FrontEndRoutingModule,
    FormsModule,
    HttpClientModule,
    BrowserAnimationsModule,
    FrontEndModule,
    AdminModule
  ],
  providers: [
    { provide: HTTP_INTERCEPTORS, useClass: JwtInterceptor, multi: true }
  ],
  bootstrap: [AppComponent]
})
export class AppModule {}
