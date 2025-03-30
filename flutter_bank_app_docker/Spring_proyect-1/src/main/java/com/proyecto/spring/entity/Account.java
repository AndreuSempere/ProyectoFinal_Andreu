package com.proyecto.spring.entity;

import java.util.List;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;

@Entity
@Table(name = "accounts")
public class Account {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_cuenta")
    private Long id_cuenta;

    @Column(name = "numero_cuenta", unique = true, nullable = false, length = 34)
    private String numeroCuenta;

    @Column(nullable = false)
    private Double saldo;

    @Column(nullable = false)
    private String estado;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private String icon;

    @ManyToOne 
    @JoinColumn(name = "id_type", nullable = false)
    private AccountType accounts_type;

    @ManyToOne
    @JoinColumn(name = "id_user", nullable = false)
    private User id_user;

    @OneToMany(mappedBy = "account", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<CreditCard> credit_card;

    @OneToMany(mappedBy = "account", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Transaction> transactions;

    // Getters y Setters

    public Long getId_cuenta() {
        return id_cuenta;
    }

    public void setId_cuenta(Long id_cuenta) {
        this.id_cuenta = id_cuenta;
    }

    public String getNumero_cuenta() {
        return numeroCuenta;
    }

    public void setNumero_cuenta(String numero_cuenta) {
        this.numeroCuenta = numero_cuenta;
    }

    public Double getSaldo() {
        return saldo;
    }

    public void setSaldo(Double saldo) {
        this.saldo = saldo;
    }

    public String getEstado() {
        return estado;
    }

    public void setEstado(String estado) {
        this.estado = estado;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public AccountType getAccounts_type() {
        return accounts_type;
    }

    public void setAccounts_type(AccountType accounts_type) {
        this.accounts_type = accounts_type;
    }

    public User getId_user() {
        return id_user;
    }

    public void setId_user(User id_user) {
        this.id_user = id_user;
    }

    public List<CreditCard> getCredit_card() {
        return credit_card;
    }

    public void setCredit_card(List<CreditCard> credit_card) {
        this.credit_card = credit_card;
    }

    public List<Transaction> getTransactions() {
        return transactions;
    }

    public void setTransactions(List<Transaction> transactions) {
        this.transactions = transactions;
    }
}