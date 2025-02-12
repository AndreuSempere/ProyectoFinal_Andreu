package com.proyecto.spring.dto;

import io.swagger.v3.oas.annotations.media.Schema;

public class CreateTransactionDto {

	@Schema(description = "Cuenta que envia la transaccion", example = "8788487544168775")
    private Long accountId;
    
	@Schema(description = "Cuenta que recibe la transaccion", example = "6372254043924801")
    private Long targetAccountId;

	@Schema(description = "Cantidad a enviar", example = "10.0")
	private Double cantidad;

	@Schema(description = "El tipo de la transaccion", example = "gasto")
    private String tipo;
	
	@Schema(description = "Descripción de la transaccion", example = "Esto es una transferencia desde swagger")
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
