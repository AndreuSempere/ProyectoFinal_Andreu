package com.proyecto.spring.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.proyecto.spring.dto.CreateTransactionDto;
import com.proyecto.spring.entity.Transaction;
import com.proyecto.spring.service.TransactionService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;

import java.util.concurrent.CompletableFuture;
import java.util.List;

@RestController
@RequestMapping("/transactions")
public class TransactionController {


	private final TransactionService transactionService;

    public TransactionController(TransactionService transactionService) {
        this.transactionService = transactionService;
    }

    @Operation(summary = "Obtener todas las transacciones", description = "Devuelve la lista de todas las transacciones")
    @ApiResponse(responseCode = "200", description = "Transacciones obtenidos con éxito")
    @GetMapping("/all")
    public List<Transaction> getTransactionAll() {
        return transactionService.getTransactionAll();
    }

    @Operation(summary = "Crear un nueva transaccion", description = "Crea una nueva transacciones en el sistema")
    @ApiResponse(responseCode = "201", description = "Transaccion creado con éxito")
    @PostMapping
    public CompletableFuture<ResponseEntity<String>> createTransaction(
            @RequestBody CreateTransactionDto dto) {
        return transactionService.createTransaction(dto)
                .thenApply(ResponseEntity::ok);
    }

    @Operation(summary = "Crear un bizum", description = "Crea un nuevo bizum en el sistema")
    @ApiResponse(responseCode = "201", description = "Bizum creado con éxito")
    @PostMapping("/bizum")
    public CompletableFuture<ResponseEntity<String>> bizumTransaction(
            @RequestBody CreateTransactionDto dto) {
        return transactionService.bizumTransaction(dto)
                .thenApply(ResponseEntity::ok);
    }
}
