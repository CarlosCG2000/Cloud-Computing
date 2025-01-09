package controllers;

import play.mvc.Controller;
import play.mvc.Result;

public class HealthCheckController extends Controller {

    public Result check() {
        return ok("Healthy");
    }
}
