import { NgModule } from "@angular/core";
import { ThemeModule } from "./views/theme/theme.module";
import { PagesModule } from "./views/pages/pages.module";

@NgModule({
  declarations: [],
  imports: [ThemeModule, PagesModule],
  exports: [ThemeModule, PagesModule]
})
export class FrontEndModule {}
