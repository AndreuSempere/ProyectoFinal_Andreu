from PySide6.QtWidgets import QApplication, QMainWindow
import sys
from Datafono import Ui_Form_Datafono  
import requests


class ValidaciónVentana(QMainWindow):
    def __init__(self):
        super().__init__()
        self.ui = Ui_Form_Datafono()
        self.ui.setupUi(self)
        green = '\033[92m'
        red = '\033[91m'

        self.ui.pushButton_12.clicked.connect(self.validar_tarjeta)
        self.ui.pushButton_10.clicked.connect(self.borrar_contenido) 

    def validar_tarjeta(self):
        num_tarjeta = self.ui.lineEdit.text()
        cantidad = int(self.ui.lcdNumber.value())
        print(num_tarjeta)
        print(cantidad)
        bearer_token = "c371fe56-1a54-4652-8bb5-12989949911d"
        headers = {
            "Content-Type": "application/json",
            "Authorization": f"Bearer {bearer_token}"
        }

        if len(num_tarjeta) == 16 and num_tarjeta.isdigit():
            print("Tarjeta válida")
          
            url = f"http://localhost:8080/credit_card/num/{num_tarjeta}"
            response = requests.get(url, headers=headers)
            if response.status_code == 200:
                response_json = response.json()
                print(response_json)
                account_id = response_json['accounts']['id_cuenta']

                new_data = {
                    "cantidad": cantidad,
                    "tipo": "gasto",
                    "descripcion": "Pago con Tarjeta",
                    "accountId": account_id
                }

                print(new_data)
                url_post = "http://localhost:8080/transaction/"
                post_response = requests.post(url_post, json=new_data, headers=headers)

                
                if post_response.status_code == 201:
                    try:
                        post_response_json = post_response.json()
                        print(post_response_json)
                    except requests.exceptions.JSONDecodeError:
                        print("La respuesta no es JSON, pero la transacción fue exitosa")
                        print(f"Response Text: {post_response.text}")
                        print(f"Response Code: {post_response.status_code}")
                        self.ui.mostrar_mensaje("Transacción realizada con éxito", "green")
                else:
                    print("Error al hacer el POST")
                    self.ui.mostrar_mensaje("Error al hacer el POST", "red")
            else:
                print("La tarjeta no existe")
                self.ui.mostrar_mensaje("La tarjeta no existe", "red")

        else:
            if len(num_tarjeta) != 16:
                print("Tarjeta inválida, debe tener exactamente 16 dígitos")
                self.ui.mostrar_mensaje("Tarjeta inválida, debe tener 16 dígitos", "red")

            elif not num_tarjeta.isdigit():
                print("Tarjeta inválida, debe contener solo números")
                self.ui.mostrar_mensaje("Tarjeta inválida, debe contener solo números", "red")

    def borrar_contenido(self):
        self.ui.lcdNumber.display(0)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    ventana = ValidaciónVentana()
    ventana.show()
    sys.exit(app.exec())
