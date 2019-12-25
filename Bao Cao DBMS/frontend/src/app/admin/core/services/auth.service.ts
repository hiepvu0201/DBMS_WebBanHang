import { Injectable } from "@angular/core";
import { Observable, of } from "rxjs";
import { Router } from "@angular/router";
import { map, catchError } from "rxjs/operators";
import { HttpClient } from "@angular/common/http";

const API_URL_LOGIN = "https://localhost:5001/api/auth/login";
const API_URL_LOGOUT = "https://localhost:5001/api/account/logout";
const API_URL_REGISTER = "https://localhost:5001/api/auth/register";

@Injectable({
  providedIn: "root"
})
export class AuthService {
  constructor(private http: HttpClient, private router: Router) {}

  authenticated: boolean = false;
  name: string;
  password: string;
  callbackUrl: string;

  login(user): Observable<boolean> {
    this.authenticated = false;
    return this.http
      .post<boolean>(API_URL_LOGIN, {
        username: user.username,
        password: user.password
      })
      .pipe(
        map((response: any) => {
          if (response) {
            localStorage.setItem("token", response.token);
            this.authenticated = true;
            this.password = null;
            this.router.navigateByUrl(this.callbackUrl || "admin/dashboard");
          }
          return this.authenticated;
        }),
        catchError(e => {
          this.authenticated = false;
          return of(false);
        })
      );
  }

  register(user): Observable<boolean> {
    return this.http
      .post<boolean>(API_URL_REGISTER, {
        name: user.name,
        username: user.username,
        password: user.password
      })
      .pipe(
        map((response: any) => {
          return true;
        }),
        catchError(e => {
          this.authenticated = false;
          return of(false);
        })
      );
  }

  loggedIn() {
    const token = localStorage.getItem("token");
    return token;
  }

  logout() {
    localStorage.removeItem("token");
    this.authenticated = false;
    this.http.post(API_URL_LOGOUT, null).subscribe(res => {});
    this.router.navigateByUrl("/admin/login");
  }
}
