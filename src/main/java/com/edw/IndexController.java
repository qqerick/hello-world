package com.edw;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;

/**
 * <pre>
 *     com.edw.IndexController
 * </pre>
 *
 * @author Muhammad Edwin < edwin at redhat dot com >
 * 23 Apr 2020 14:00
 */
@RestController
public class IndexController {
    @GetMapping("/")
    public HashMap helloWorld() {
        return new HashMap<>(){{
            put("Message", "Ejemplo con Erick Quispe...");
        }};
    }
}
