package com.proyecto.spring.service;

import java.util.List;
import java.util.concurrent.CompletableFuture;

import org.hibernate.Hibernate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.validation.annotation.Validated;

import com.proyecto.spring.dto.CreateTransactionDto;
import com.proyecto.spring.entity.Account;
import com.proyecto.spring.entity.Transaction;
import com.proyecto.spring.entity.User;
import com.proyecto.spring.repository.AccountRepository;
import com.proyecto.spring.repository.TransactionRepository;
import com.proyecto.spring.repository.UserRepository;

import jakarta.transaction.Transactional;

@Service
@Validated
public class TransactionService {

    @Autowired
    private  TransactionRepository transactionRepository;
    @Autowired
    private  AccountRepository accountRepository;
    @Autowired
    private  UserRepository userRepository;
    
    public TransactionService(UserRepository userRepository, AccountRepository accountRepository, TransactionRepository transactionRepository) {
				this.userRepository = userRepository;
				this.accountRepository = accountRepository;
				this.transactionRepository = transactionRepository;
    		}

    
    public List<Transaction> getTransactionAll() {
        return transactionRepository.findAll();
    }
    
    @Async
    @Transactional
    public CompletableFuture<String> createTransaction(CreateTransactionDto dto) {
        return CompletableFuture.supplyAsync(() -> {
            System.out.println("DTO recibido: accountId=" + dto.getAccountId() + 
                               ", targetAccountId=" + dto.getTargetAccountId() + 
                               ", cantidad=" + dto.getCantidad() + ", tipo=" + dto.getTipo());

        Account origenAccount = accountRepository.findById(dto.getAccountId())
                .orElseThrow(() -> {
                    System.out.println("Cuenta origen no encontrada con ID: " + dto.getAccountId());
                    return new RuntimeException("Cuenta origen no encontrada");
                });

        System.out.println("Cuenta origen encontrada: " + origenAccount.getId_cuenta() + 
                           ", saldo: " + origenAccount.getSaldo());

        Account targetAccount = null;
        if (dto.getTargetAccountId() != null) {
            targetAccount = accountRepository.findById(dto.getTargetAccountId())
                    .orElseThrow(() -> {
                        System.out.println("Cuenta destino no encontrada con ID: " + dto.getTargetAccountId());
                        return new RuntimeException("Cuenta destino no encontrada");
                    });
            System.out.println("Cuenta destino encontrada: " + targetAccount.getId_cuenta() + 
                               ", saldo: " + targetAccount.getSaldo());
        }

        if ("ingreso".equals(dto.getTipo())) {
            origenAccount.setSaldo(origenAccount.getSaldo() + dto.getCantidad());
        } else if ("gasto".equals(dto.getTipo())) {
            if (origenAccount.getSaldo() < dto.getCantidad()) {
                throw new RuntimeException("Fondos insuficientes en la cuenta origen");
            }
            origenAccount.setSaldo(origenAccount.getSaldo() - dto.getCantidad());

            if (targetAccount != null) {
                targetAccount.setSaldo(targetAccount.getSaldo() + dto.getCantidad());
            }
        } else {
            throw new RuntimeException("Tipo de transacción inválido");
        }

        Transaction sourceTransaction = new Transaction();
        sourceTransaction.setAccount(origenAccount);
        sourceTransaction.setCantidad(dto.getCantidad());
        sourceTransaction.setTipo("gasto".equals(dto.getTipo()) ? "gasto" : "ingreso");
        sourceTransaction.setDescripcion(dto.getDescripcion() != null ? dto.getDescripcion() : "Transferencia");

        Transaction targetTransaction = null;
        if (targetAccount != null) {
            targetTransaction = new Transaction();
            targetTransaction.setAccount(targetAccount);
            targetTransaction.setCantidad(dto.getCantidad());
            targetTransaction.setTipo("ingreso");
            targetTransaction.setDescripcion(dto.getDescripcion() != null ? dto.getDescripcion() : "Transferencia recibida");
        }

        // Guardar transacciones y cuentas
        accountRepository.save(origenAccount);
        
        // Guardar transacción de origen después de guardar la cuenta
        transactionRepository.save(sourceTransaction);
        
        // Solo si hay cuenta destino, guardar la transacción y cuenta destino
        if (targetAccount != null) {
            accountRepository.save(targetAccount);
            transactionRepository.save(targetTransaction);
        }

        System.out.println("Transacción procesada con éxito");
        return "Transacción procesada con éxito";
        });
    }


    @Async
    @Transactional
    public CompletableFuture<String> bizumTransaction(CreateTransactionDto dto) {
        return CompletableFuture.supplyAsync(() -> {
            User sourceUser = userRepository.findByTelf(dto.getAccountId().toString())
                    .orElseThrow(() -> new RuntimeException("Cuenta origen no encontrada"));

            Hibernate.initialize(sourceUser.getAccounts());
            Account sourceAccount = sourceUser.getAccounts().stream()
                    .findFirst()
                    .orElseThrow(() -> new RuntimeException("Cuenta origen no encontrada"));

            if (dto.getTipo().equals("ingreso")) {
                sourceAccount.setSaldo(sourceAccount.getSaldo() + dto.getCantidad());
            } else if (dto.getTipo().equals("gasto")) {
                if (sourceAccount.getSaldo() < dto.getCantidad()) {
                    throw new RuntimeException("Fondos insuficientes");
                }
                sourceAccount.setSaldo(sourceAccount.getSaldo() - dto.getCantidad());
            } else {
                throw new RuntimeException("Tipo de transacción inválido");
            }

            Account targetAccount = null;
            if (dto.getTargetAccountId() != null) {
                User targetUser = userRepository.findByTelf(dto.getTargetAccountId().toString())
                        .orElseThrow(() -> new RuntimeException("Cuenta destino no encontrada"));

                Hibernate.initialize(targetUser.getAccounts());
                targetAccount = targetUser.getAccounts().stream()
                        .findFirst()
                        .orElseThrow(() -> new RuntimeException("Cuenta destino no encontrada"));

                if (dto.getTipo().equals("gasto")) {
                    targetAccount.setSaldo(targetAccount.getSaldo() + dto.getCantidad());
                }
            }

            Transaction sourceTransaction = new Transaction();
            sourceTransaction.setAccount(sourceAccount);
            sourceTransaction.setCantidad(dto.getCantidad());
            sourceTransaction.setTipo(dto.getTipo());
            sourceTransaction.setDescripcion(dto.getDescripcion() != null ? dto.getDescripcion() : "Transferencia");
            transactionRepository.save(sourceTransaction);

            if (targetAccount != null) {
                Transaction targetTransaction = new Transaction();
                targetTransaction.setAccount(targetAccount);
                targetTransaction.setCantidad(dto.getCantidad());
                targetTransaction.setTipo("ingreso");
                targetTransaction.setDescripcion(dto.getDescripcion() != null ? dto.getDescripcion() : "Bizum recibido");
                transactionRepository.save(targetTransaction);
            }

            accountRepository.save(sourceAccount);
            if (targetAccount != null) {
                accountRepository.save(targetAccount);
            }

            return "Bizum procesado con éxito";
        });
    }
}
