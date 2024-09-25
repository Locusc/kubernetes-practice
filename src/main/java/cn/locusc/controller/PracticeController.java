package cn.locusc.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class PracticeController {

    @RequestMapping("/")
    public String index() {
        return "testing for CI/CD";
    }

}
