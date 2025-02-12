from odoo import models, fields, api
from odoo.exceptions import UserError

class PdfGenerator(models.TransientModel):
    _name = 'pdf.generator'
    _description = 'Generador de PDF para justificación de pago'

    cantidad = fields.Float(string="Cantidad")
    tipo = fields.Selection([('gasto', 'Gasto'), ('ingreso', 'Ingreso')], string="Tipo")
    descripcion = fields.Char(string="Descripción")
    account_id = fields.Char(string="Cuenta Remitente")
    target_account_id = fields.Char(string="Cuenta Destinataria")

    @api.model
    def create_from_json(self, json_data):
        """Método para crear un registro desde el JSON"""
        return self.create({
            'cantidad': json_data.get('cantidad'),
            'tipo': json_data.get('tipo'),
            'descripcion': json_data.get('descripcion'),
            'account_id': json_data.get('accountId'),
            'target_account_id': json_data.get('targetAccountId'),
        })

    def generate_pdf(self):
        data = {
            'empresa_nombre': 'Bankify',
            'logo': '/pdf_generator/static/src/img/icono_app.png',
            'account_id': self.account_id,
            'target_account_id': self.target_account_id,
            'cantidad': self.cantidad,
            'tipo': self.tipo,
            'descripcion': self.descripcion
        }

        # Asegúrate de que los valores no sean listas
        for key, value in data.items():
            if isinstance(value, list):
                raise UserError(f"El campo '{key}' contiene una lista en lugar de un valor esperado.")

        pdf_content = self.env.ref('pdf_generator.report_pdf_template').render(data)
        return pdf_content
