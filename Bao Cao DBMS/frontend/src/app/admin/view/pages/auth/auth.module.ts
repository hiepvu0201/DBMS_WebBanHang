// Angular
import { NgModule } from "@angular/core";
import { RouterModule } from "@angular/router";
import { CommonModule } from "@angular/common";
import { FormsModule } from "@angular/forms";

// Materials
import { MatIconModule } from "@angular/material";

// Components
import { AuthComponent } from "./auth.component";

@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    RouterModule.forChild([
      {
        path: "",
        component: AuthComponent,
        children: [
          {
            path: "login",
            component: AuthComponent,
            data: { returnUrl: window.location.pathname }
          }
        ]
      }
    ]),

    // MATERIALS
    MatIconModule
  ],
  entryComponents: [],
  providers: [],
  declarations: [AuthComponent]
})
export class AuthModule {}
