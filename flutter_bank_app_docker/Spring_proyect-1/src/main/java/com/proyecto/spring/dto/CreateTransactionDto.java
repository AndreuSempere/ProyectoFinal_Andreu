package com.proyecto.spring.dto;


public class CreateTransactionDto {

    private Long accountId;
    
    private Long targetAccountId;

    private Double cantidad;

    private String tipo;

    private String descripcion;

    // Getters y Setters manuales
    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
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
    
    public Long getTargetAccountId() {
        return targetAccountId;
    }
}
