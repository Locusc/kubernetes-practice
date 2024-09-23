package cn.locusc.controller;

import org.springframework.web.bind.annotation.RequestMapping;

public class PracticeController {

    @RequestMapping("/")
    public String index() {
        return "testing for CI/CD";
    }

}
