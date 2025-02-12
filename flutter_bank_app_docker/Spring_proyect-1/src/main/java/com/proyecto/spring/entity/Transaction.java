package com.proyecto.spring.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
public class Transaction {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_transaction;

    @ManyToOne
    @JoinColumn(name = "accountId", nullable = false)
    private Account account;

    @ManyToOne
    @JoinColumn(name = "targetAccountId")
    private Account targetAccount;

    @Column(nullable = false)
    private Double cantidad;

    @Column(nullable = false)
    private String tipo;

    @Column
    private String descripcion;

    @Column(nullable = false)
    private LocalDateTime created_at = LocalDateTime.now();

    // Getters y Setters

    public Long getId_transaction() {
        return id_transaction;
    }

    public void setId_transaction(Long id_transaction) {
        this.id_transaction = id_transaction;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }

    public Account getTargetAccount() {
        return targetAccount;
    }

    public void setTargetAccount(Account targetAccount) {
        this.targetAccount = targetAccount;
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getDescripcion() {
        return descripcion;
    }

    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    public LocalDateTime getCreatedAt() {
        return created_at;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.created_at = createdAt;
    }
}
