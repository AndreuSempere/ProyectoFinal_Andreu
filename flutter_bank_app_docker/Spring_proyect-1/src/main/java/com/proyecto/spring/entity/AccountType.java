package com.proyecto.spring.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "accounts_type")
public class AccountType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_type;

    @Column(nullable = false)
    private String description;

    @OneToMany(mappedBy = "accounts_type", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Account> accounts;

    // Getters y Setters

    public Long getId_type() {
        return id_type;
    }

    public void setId_type(Long id_type) {
        this.id_type = id_type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<Account> getAccounts() {
        return accounts;
    }

    public void setAccounts(List<Account> accounts) {
        this.accounts = accounts;
    }
}
