import requests
import json
from odoo import models, fields, api, _
from odoo.exceptions import UserError

class AccionCron(models.Model):
    _name = "accion.cron"
    _description = "Accion para actualizar trading"

    name = fields.Char(string="Nombre", default="Actualizar Trading")

    @api.model
    def _update_tradding(self):

        url_get = "http://financial_api:8000/all"
        url_post = "http://web_server:3000/trading"

        try:
            response_get = requests.get(url_get, timeout=10)
            if response_get.status_code != 200:
                raise UserError(_("Error en GET: %s") % response_get.text)

            data = response_get.json()

            if not data or not any(data.values()):
                raise UserError(_("No se obtuvieron datos válidos de GET"))
            
            transformed_data = []
            
            for stock in data.get("stocks", []):
                transformed_data.append({
                    "type": "Acción",
                    "name": stock.get("name"),
                    "symbol": stock.get("symbol"),
                    "price": stock.get("price")
                })
            
            for crypto in data.get("crypto", []):
                transformed_data.append({
                    "type": "Criptomoneda",
                    "name": crypto.get("name"),
                    "symbol": crypto.get("symbol"),
                    "price": crypto.get("price")
                })
            
            for commodity in data.get("commodities", []):
                transformed_data.append({
                    "type": "Materia Prima",
                    "name": commodity.get("name"),
                    "symbol": commodity.get("symbol"),
                    "price": commodity.get("price")
                })
            
            success_count = 0
            error_count = 0
            bearer_token = "c371fe56-1a54-4652-8bb5-12989949911d"
            
            for item in transformed_data:
                try:
                    headers = {
                        "Content-Type": "application/json",
                        "Authorization": f"Bearer {bearer_token}"
                    }
                    response_post = requests.post(url_post, data=json.dumps(item), headers=headers, timeout=10)
                    print(response_post.text)
                    
                    if response_post.status_code in [200, 201]:
                        success_count += 1
                    else:
                        error_count += 1
                        self.env.cr.commit()
                except Exception as e:
                    error_count += 1
                    self.env.cr.commit()
            
            if error_count > 0:
                if success_count > 0:
                    return True 
                else:
                    raise UserError(_("No se pudo guardar ningún registro en POST"))
            
            return True

        except requests.RequestException as e:
            raise UserError(_("Error de conexión: %s") % str(e))
