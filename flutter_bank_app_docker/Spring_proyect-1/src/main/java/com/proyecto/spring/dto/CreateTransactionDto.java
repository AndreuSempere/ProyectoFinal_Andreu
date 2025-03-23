package com.proyecto.spring.dto;

import io.swagger.v3.oas.annotations.media.Schema;

public class CreateTransactionDto {

	@Schema(description = "ID de la transacción, puede ser null para nuevas transacciones", example = "null")
    private Long id_transaction;
    
	@Schema(description = "ID de la cuenta que envía la transacción", example = "1")
    private Long accountId;
    
	@Schema(description = "ID de la cuenta que recibe la transacción", example = "2")
    private Long targetAccountId;

	@Schema(description = "Cantidad a enviar", example = "10.0")
	private Double cantidad;

	@Schema(description = "El tipo de la transacción", example = "gasto")
    private String tipo;
	
	@Schema(description = "Descripción de la transacción", example = "Esto es una transferencia")
    private String descripcion;

    // Getters y Setters
    public Long getId_transaction() {
        return id_transaction;
    }

    public void setId_transaction(Long id_transaction) {
        this.id_transaction = id_transaction;
    }
    
    public Long getAccountId() {
        return accountId;
    }

    public void setAccountId(Long accountId) {
        this.accountId = accountId;
    }

    public Long getTargetAccountId() {
        return targetAccountId;
    }

    public void setTargetAccountId(Long targetAccountId) {
        this.targetAccountId = targetAccountId;
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
}
