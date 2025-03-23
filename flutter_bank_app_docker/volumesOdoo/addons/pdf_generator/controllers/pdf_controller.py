from odoo import http
from odoo.http import request, Response
from reportlab.lib.pagesizes import letter
from reportlab.lib import colors
from reportlab.pdfgen import canvas
from reportlab.platypus import Image
import io
import os
from datetime import datetime

class TransactionController(http.Controller):
    
    @http.route('/generate/pdf', type='http', auth='public', methods=['POST'], csrf=False)
    def generate_pdf(self, **kwargs):
        try:
            # Acceder a los datos del JSON
            data = request.httprequest.get_json()
            
            # Extraer todos los campos del JSON
            cantidad = data.get('cantidad')
            tipo = data.get('tipo', 'Transferencia')
            descripcion = data.get('descripcion', 'Sin descripción')
            
            # Información de cuenta origen
            account_number = data.get('accountNumber', '')
            user_name = data.get('userName', '')
            user_surname = data.get('userSurname', '')
            
            # Información de cuenta destino
            target_account_number = data.get('targetAccountNumber', '')
            target_user_name = data.get('targetUserName', '')
            target_user_surname = data.get('targetUserSurname', '')
            

            # Validar campos obligatorios
            if not cantidad:
                return {'error': 'Faltan datos obligatorios en el JSON (cantidad)'}
            
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
            
            # Fecha y hora actual
            current_time = datetime.now().strftime("%d/%m/%Y %H:%M:%S")
            p.setFont("Helvetica", 10)
            p.drawString(400, 750, f"Fecha: {current_time}")
            
            # Línea de separación
            p.setStrokeColor(colors.HexColor("#D1D3D4"))
            p.setLineWidth(1)
            p.line(50, 740, 550, 740)

            # Detalles de la transacción
            p.setFont("Helvetica-Bold", 12)
            p.setFillColor(colors.black)
            p.drawString(50, 710, "DETALLES DE LA TRANSACCIÓN")
            
            p.setFont("Helvetica", 12)
            p.drawString(50, 680, f"Importe: {cantidad} €")
            p.drawString(50, 660, f"Tipo: {tipo}")
            p.drawString(50, 640, f"Concepto: {descripcion}")
            
            # Información de cuenta origen
            p.setFont("Helvetica-Bold", 12)
            p.drawString(50, 610, "CUENTA ORIGEN")
            p.setFont("Helvetica", 12)
            if user_name or user_surname:
                p.drawString(50, 590, f"Titular: {user_name} {user_surname}")
            p.drawString(50, 570, f"Número: {account_number}")
            
            # Información de cuenta destino (si existe)
            if target_account_number:
                p.setFont("Helvetica-Bold", 12)
                p.drawString(50, 520, "CUENTA DESTINO")
                p.setFont("Helvetica", 12)
                if target_user_name or target_user_surname:
                    p.drawString(50, 500, f"Titular: {target_user_name} {target_user_surname}")
                p.drawString(50, 480, f"Número: {target_account_number}")
            
            # Agregar líneas horizontales para un formato más limpio
            p.setStrokeColor(colors.HexColor("#D1D3D4"))
            p.line(50, 440, 550, 440)

            # Información legal
            p.setFont("Helvetica-Oblique", 8)
            p.drawString(50, 100, "Este documento es un justificante de la operación realizada y no constituye un documento fiscal.")
            p.drawString(50, 90, "Para cualquier reclamación, conserve este documento como prueba de la transacción.")
            
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
