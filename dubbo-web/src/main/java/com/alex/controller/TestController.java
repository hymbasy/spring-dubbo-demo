package com.alex.controller;

import com.alex.model.Users;
import com.alex.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.List;

@Controller
public class TestController {

    @Autowired
    private TestService testService;

    @RequestMapping("/test")
    public String hello(Model model) {
        List<Users> usersList = testService.hello();
        model.addAttribute("userList",usersList);
        return "index";
    }
}
