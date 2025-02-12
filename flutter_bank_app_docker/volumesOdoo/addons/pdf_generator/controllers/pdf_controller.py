import base64
import json
from odoo import http
from odoo.http import request
from odoo.exceptions import UserError

class PDFGeneratorController(http.Controller):

    @http.route('/pdf/generate', type='json', auth='public', methods=['POST'])
    def generate_pdf(self, **kwargs):
        try:
            # Recibe datos en JSON
            data = request.httprequest.data
            json_data = json.loads(data)

            # Depuración para imprimir los valores de json_data
            print(json_data)  # Verifica que los valores no sean listas

            # Asegurarse de que ninguno de los campos es una lista
            for key, value in json_data.items():
                if isinstance(value, list):
                    raise UserError(f"El campo '{key}' contiene una lista en lugar de un valor esperado.")

            # Crea un nuevo registro en el modelo
            pdf_record = request.env['pdf.generator'].sudo().create({
                'cantidad': json_data.get('cantidad'),
                'tipo': json_data.get('tipo'),
                'descripcion': json_data.get('descripcion'),
                'account_id': json_data.get('accountId'),
                'target_account_id': json_data.get('targetAccountId'),
            })

            # Genera el PDF con el ID del nuevo registro
            pdf_content, content_type = request.env.ref('pdf_generator.action_pdf_report').sudo()._render_qweb_pdf(pdf_record.id)

            # Codificar en base64 para devolverlo
            pdf_base64 = base64.b64encode(pdf_content).decode()

            return {
                'success': True,
                'pdf': pdf_base64,
                'filename': f"{pdf_record.name}.pdf"
            }
        except Exception as e:
            return {'success': False, 'error': str(e)}
