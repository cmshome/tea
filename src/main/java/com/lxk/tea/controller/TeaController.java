package com.lxk.tea.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * @author LiXuekai on 2021/7/2
 */
@RestController
@RequestMapping("/tea")
public class TeaController {

    @GetMapping("/test")
    public String test() {

        String json = "{\n" +
                "    \"errCode\":null,\n" +
                "    \"message\":null,\n" +
                "    \"data\":{\n" +
                "        \"userNo\":\"admin\"\n" +
                "    },\n" +
                "    \"mode\":\"offline\",\n" +
                "    \"language\":\"zh_CN\"\n" +
                "}";

        return json;
    }





}
