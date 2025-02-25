from odoo import http
from odoo.http import request, Response
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.pdfgen import canvas
from reportlab.platypus import Image
import io
import os

class TransactionController(http.Controller):
    
    @http.route('/generate/pdf', type='http', auth='public', methods=['POST'], csrf=False)
    def generate_pdf(self, **kwargs):
        try:
            # Acceder a los datos del JSON
            data = request.httprequest.get_json()
            cantidad = data.get('cantidad')
            tipo = data.get('tipo')
            descripcion = data.get('descripcion')
            account_id = data.get('accountId')
            target_account_id = data.get('targetAccountId')
            
            if not all([cantidad, tipo, descripcion, account_id, target_account_id]):
                return {'error': 'Faltan datos en el JSON'}
            
            # Crear PDF
            pdf_buffer = io.BytesIO()
            p = canvas.Canvas(pdf_buffer, pagesize=letter)
            
            # Fuentes y estilos
            p.setFont("Helvetica-Bold", 16)
            p.setFillColor(colors.HexColor("#00539C"))  # Color de texto principal

            # Ruta de la imagen en el módulo de Odoo
            image_path = os.path.join(os.path.dirname(__file__), '../static/src/img/icono_app.png')
            
            if os.path.exists(image_path):
                p.drawImage(image_path, 50, 750, width=60, height=60)

            # Encabezado
            p.drawString(150, 770, "Bankify - Justificante de Pago")
            
            # Línea de separación
            p.setStrokeColor(colors.HexColor("#D1D3D4"))
            p.setLineWidth(1)
            p.line(50, 740, 550, 740)

            # Detalles de la transacción
            p.setFont("Helvetica", 12)
            p.setFillColor(colors.black)

            p.drawString(50, 700, f"Cantidad: {cantidad} {tipo}")
            p.drawString(50, 680, f"Descripción: {descripcion}")
            p.drawString(50, 660, f"De: {account_id}")
            p.drawString(50, 640, f"Para: {target_account_id}")

            # Agregar líneas horizontales para un formato más limpio
            p.line(50, 630, 550, 630)

            # Footer - Firma y detalles
            p.setFont("Helvetica-Oblique", 10)
            p.drawString(50, 50, "Firma del remitente")
            p.drawString(400, 50, "Firma del receptor")

            # Salvar y terminar
            p.save()
            
            pdf_buffer.seek(0)
            
            # Usar make_response para enviar el archivo PDF de manera correcta
            headers = [('Content-Type', 'application/pdf'),
                       ('Content-Disposition', 'attachment; filename=transaction.pdf')]
            
            # Devolver el PDF como respuesta binaria
            return request.make_response(pdf_buffer.read(), headers=headers)
        
        except Exception as e:
            return {'error': str(e)}
