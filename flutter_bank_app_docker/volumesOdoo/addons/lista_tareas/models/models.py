# -*- coding: utf-8 -*-
from odoo import models, fields, api

# Definimos el modelo de datos
class ListaTareas(models.Model):
    # Nombre y descripción del modelo de datos
    _name = 'lista_tareas.lista_tareas'
    _description = 'Lista de Tareas'

    # Elementos de cada fila del modelo de datos
    # Los tipos de datos a usar en el ORM son:
    # https://www.odoo.com/documentation/14.0/developer/reference/addons/orm.html#fields
    tarea = fields.Char(string="Tarea")
    prioridad = fields.Integer(string="Prioridad")
    urgente = fields.Boolean(string="Urgente", compute="_value_urgente", store=True)
    realizada = fields.Boolean(string="Realizada")

    # Este cómputo depende de la variable prioridad
    @api.depends('prioridad')
    def _value_urgente(self):
        # Para cada registro
        for record in self:
            # Si la prioridad es mayor que 10, se considera urgente, en otro caso no lo es
            record.urgente = record.prioridad > 10
