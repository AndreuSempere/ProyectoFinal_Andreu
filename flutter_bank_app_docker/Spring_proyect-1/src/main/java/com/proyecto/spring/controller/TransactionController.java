package com.proyecto.spring.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.proyecto.spring.dto.CreateTransactionDto;
import com.proyecto.spring.entity.Transaction;
import com.proyecto.spring.service.TransactionService;


import java.util.concurrent.CompletableFuture;
import java.util.List;

@RestController
@RequestMapping("/transactions")
public class TransactionController {


	private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    @GetMapping("/all")
    public List<Transaction> getTransactionAll() {
        return transactionService.getTransactionAll();
    }

    @PostMapping
    public CompletableFuture<ResponseEntity<String>> createTransaction(
            @RequestBody CreateTransactionDto dto) {
        return transactionService.createTransaction(dto)
                .thenApply(ResponseEntity::ok);
    }

    @PostMapping("/bizum")
    public CompletableFuture<ResponseEntity<String>> bizumTransaction(
            @RequestBody CreateTransactionDto dto) {
        return transactionService.bizumTransaction(dto)
                .thenApply(ResponseEntity::ok);
    }
}
