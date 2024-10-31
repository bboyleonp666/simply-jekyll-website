package com.city4crew.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.city4crew.data.ContactUsRequest;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.IOException;
import java.util.stream.Collectors;

@RestController
public class MailServiceApiHandler {

    Logger logger = LoggerFactory.getLogger(MailServiceApiHandler.class);

    @GetMapping("/")
    public String index() {
        return "Greetings from City4 Crew!";
    }

    @PostMapping("/contactus")
    public ResponseEntity<String> handleContactUs(@RequestBody ContactUsRequest request) {
        String messageReceived = String.format(
                "Name: %s, Phone: %s, Email: %s, Message: %s",
                request.getName(), request.getPhone(), request.getEmail(), request.getMessage());
        logger.debug("message received: {}", messageReceived);

        // Call gmail api to send message
        try {
            File workingDirectory = new File("../gmail_api");

            ProcessBuilder processBuilder = new ProcessBuilder(
                    "python", "send_message.py", "--message", messageReceived);
            processBuilder.directory(workingDirectory); // Set the working directory
            processBuilder.redirectErrorStream(true);
            Process process = processBuilder.start();

            String output = new BufferedReader(new InputStreamReader(process.getInputStream()))
                    .lines()
                    .collect(Collectors.joining("\n"));

            logger.info("Gmail script output: {}", output);

        } catch (IOException e) {
            logger.error("Error calling Python script", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error processing request");
        }

        return ResponseEntity.ok("Message Received");
    }


}
