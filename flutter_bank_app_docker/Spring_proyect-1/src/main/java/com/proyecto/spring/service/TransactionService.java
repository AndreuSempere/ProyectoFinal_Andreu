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
        	Account origenAccount = accountRepository.findByNumeroCuenta(dto.getAccountId())
        	        .orElseThrow(() -> new RuntimeException("Cuenta origen no encontrada"));

            if (dto.getTipo().equals("ingreso")) {
                origenAccount.setSaldo(origenAccount.getSaldo() + dto.getCantidad());
            } else if (dto.getTipo().equals("gasto") && origenAccount.getSaldo() < dto.getCantidad()) {
                throw new RuntimeException("Fondos insuficientes");
            } else {
                origenAccount.setSaldo(origenAccount.getSaldo() - dto.getCantidad());
            }

            Transaction transaction = new Transaction();
            transaction.setAccount(origenAccount);
            transaction.setCantidad(dto.getCantidad());
            transaction.setTipo(dto.getTipo());
            transaction.setDescripcion(dto.getDescripcion() != null ? dto.getDescripcion() : "Transferencia");

            transactionRepository.save(transaction);
            accountRepository.save(origenAccount);

            return "Transacción procesada con éxito";
        });
    }

    @Async
    @Transactional
    public CompletableFuture<String> bizumTransaction(CreateTransactionDto dto) {
        return CompletableFuture.supplyAsync(() -> {
            User sourceUser = userRepository.findByTelf(dto.getAccountId())
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
                User targetUser = userRepository.findByTelf(dto.getTargetAccountId())
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
