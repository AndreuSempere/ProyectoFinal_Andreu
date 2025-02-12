package com.proyecto.spring.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.proyecto.spring.entity.Transaction;


@Repository
public interface TransactionRepository extends JpaRepository<Transaction, Long> {

}
