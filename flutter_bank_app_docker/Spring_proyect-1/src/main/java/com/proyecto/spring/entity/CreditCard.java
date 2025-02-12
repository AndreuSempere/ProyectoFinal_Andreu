package com.proyecto.spring.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "credit_card")
public class CreditCard {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id_tarjeta;

    @Column(nullable = false, unique = true)
    private Long numero_tarjeta;

    @Column(nullable = false)
    private String tipo_tarjeta;

    @Column(nullable = false)
    private String cardHolderName;

    @Column(nullable = true)
    private String fecha_expiracion;

    @Column(nullable = false)
    private Integer cvv;

    @Column(nullable = false)
    private Integer color;

    @ManyToOne
    @JoinColumn(name = "id_cuenta", nullable = false)
    private Account account;

    // Getters y Setters

    public Long getId_tarjeta() {
        return id_tarjeta;
    }

    public void setId_tarjeta(Long id_tarjeta) {
        this.id_tarjeta = id_tarjeta;
    }

    public Long getNumero_tarjeta() {
        return numero_tarjeta;
    }

    public void setNumero_tarjeta(Long numero_tarjeta) {
        this.numero_tarjeta = numero_tarjeta;
    }

    public String getTipo_tarjeta() {
        return tipo_tarjeta;
    }

    public void setTipo_tarjeta(String tipo_tarjeta) {
        this.tipo_tarjeta = tipo_tarjeta;
    }

    public String getCardHolderName() {
        return cardHolderName;
    }

    public void setCardHolderName(String cardHolderName) {
        this.cardHolderName = cardHolderName;
    }

    public String getFecha_expiracion() {
        return fecha_expiracion;
    }

    public void setFecha_expiracion(String fecha_expiracion) {
        this.fecha_expiracion = fecha_expiracion;
    }

    public Integer getCvv() {
        return cvv;
    }

    public void setCvv(Integer cvv) {
        this.cvv = cvv;
    }

    public Integer getColor() {
        return color;
    }

    public void setColor(Integer color) {
        this.color = color;
    }

    public Account getAccounts() {
        return account;
    }

    public void setAccounts(Account accounts) {
        this.account = accounts;
    }
}
