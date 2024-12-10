package com.example.demo.service;

import org.springframework.stereotype.Service;

@Service
public class MessageService {
    
    public MessageService() {
        System.out.println("MessageService has been created");
    }

    public String getWelcomeMessage(String username) {
        if (username == null || username.isEmpty()) {
            return "Welcome, !";
        }
        return "Welcome, " + username + "!";
    }
}
