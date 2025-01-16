from PyQt6 import QtCore, QtGui, QtWidgets

class Ui_Form_Datafono(object):
    def setupUi(self, Form):
        Form.setObjectName("Form")
        Form.resize(529, 577)

        # Etiqueta
        self.label = QtWidgets.QLabel(parent=Form)
        self.label.setGeometry(QtCore.QRect(120, 10, 331, 61))
        self.label.setObjectName("label")
        self.label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.label.setStyleSheet("font-size: 11pt; font-weight: bold;")  
        self.label.setText("Introduce la tarjeta a la que se le hará el cobro")

        # LCD
        self.lcdNumber = QtWidgets.QLCDNumber(parent=Form)
        self.lcdNumber.setGeometry(QtCore.QRect(170, 160, 211, 51))
        self.lcdNumber.setObjectName("lcdNumber")
        self.lcdNumber.setMode(QtWidgets.QLCDNumber.Mode.Dec)  # Asegura que solo se muestren enteros

        self.lineEdit = QtWidgets.QLineEdit(parent=Form)
        self.lineEdit.setGeometry(QtCore.QRect(150, 70, 241, 31))
        self.lineEdit.setObjectName("lineEdit")

        self.widget = QtWidgets.QWidget(parent=Form)
        self.widget.setGeometry(QtCore.QRect(110, 210, 331, 361))
        self.widget.setObjectName("widget")

        # Botones numéricos
        self.pushButton_3 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_3.setGeometry(QtCore.QRect(40, 110, 75, 71))
        self.pushButton_3.setText("4")
        self.pushButton_3.setObjectName("pushButton_3")

        self.pushButton_7 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_7.setGeometry(QtCore.QRect(130, 190, 75, 71))
        self.pushButton_7.setText("8")
        self.pushButton_7.setObjectName("pushButton_7")

        self.pushButton = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton.setGeometry(QtCore.QRect(40, 30, 75, 71))
        self.pushButton.setText("1")
        self.pushButton.setObjectName("pushButton")

        self.pushButton_8 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_8.setGeometry(QtCore.QRect(220, 110, 75, 71))
        self.pushButton_8.setText("6")
        self.pushButton_8.setObjectName("pushButton_8")

        self.pushButton_6 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_6.setGeometry(QtCore.QRect(220, 30, 75, 71))
        self.pushButton_6.setText("3")
        self.pushButton_6.setObjectName("pushButton_6")

        self.pushButton_4 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_4.setGeometry(QtCore.QRect(40, 190, 75, 71))
        self.pushButton_4.setText("7")
        self.pushButton_4.setObjectName("pushButton_4")

        self.pushButton_2 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_2.setGeometry(QtCore.QRect(130, 30, 75, 71))
        self.pushButton_2.setText("2")
        self.pushButton_2.setObjectName("pushButton_2")

        self.pushButton_9 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_9.setGeometry(QtCore.QRect(220, 190, 75, 71))
        self.pushButton_9.setText("9")
        self.pushButton_9.setObjectName("pushButton_9")

        self.pushButton_10 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_10.setGeometry(QtCore.QRect(40, 280, 75, 41))
        self.pushButton_10.setText("")
        icon = QtGui.QIcon.fromTheme("QIcon::ThemeIcon::ApplicationExit")
        self.pushButton_10.setIcon(icon)
        self.pushButton_10.setObjectName("pushButton_10")
        self.pushButton_10.setStyleSheet("background-color: red;")

        self.pushButton_12 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_12.setGeometry(QtCore.QRect(220, 280, 75, 41))
        self.pushButton_12.setText("")
        icon = QtGui.QIcon.fromTheme("QIcon::ThemeIcon::MailSend")
        self.pushButton_12.setIcon(icon)
        self.pushButton_12.setObjectName("pushButton_12")
        self.pushButton_12.setStyleSheet("background-color: green;")

        self.pushButton_5 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_5.setGeometry(QtCore.QRect(130, 110, 75, 71))
        self.pushButton_5.setText("5")
        self.pushButton_5.setObjectName("pushButton_5")

        self.pushButton_11 = QtWidgets.QPushButton(parent=self.widget)
        self.pushButton_11.setGeometry(QtCore.QRect(130, 270, 75, 61))
        self.pushButton_11.setText("0")
        self.pushButton_11.setObjectName("pushButton_11")

        # Conectar los botones
        self.pushButton.clicked.connect(lambda: self.añadir_numeros("1"))
        self.pushButton_2.clicked.connect(lambda: self.añadir_numeros("2"))
        self.pushButton_6.clicked.connect(lambda: self.añadir_numeros("3"))
        self.pushButton_3.clicked.connect(lambda: self.añadir_numeros("4"))
        self.pushButton_5.clicked.connect(lambda: self.añadir_numeros("5"))
        self.pushButton_8.clicked.connect(lambda: self.añadir_numeros("6"))
        self.pushButton_4.clicked.connect(lambda: self.añadir_numeros("7"))
        self.pushButton_7.clicked.connect(lambda: self.añadir_numeros("8"))
        self.pushButton_9.clicked.connect(lambda: self.añadir_numeros("9"))
        self.pushButton_11.clicked.connect(lambda: self.añadir_numeros("0"))
        
        # Mensaje dinámico de resultado
        self.result_label = QtWidgets.QLabel(parent=Form)
        self.result_label.setGeometry(QtCore.QRect(100, 130, 331, 31))
        self.result_label.setObjectName("result_label")
        self.result_label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.result_label.setStyleSheet("font-size: 10pt; font-weight: bold;")
        self.result_label.setText("")

    def retranslateUi(self, Form):
        _translate = QtCore.QCoreApplication.translate
        Form.setWindowTitle(_translate("Form", "Form"))

    def añadir_numeros(self, num):
        current_value = int(self.lcdNumber.value())  # Obtener el valor actual
        new_value = int(str(current_value) + num)
        self.lcdNumber.display(new_value)  # Mostrar el nuevo valor en el LCD

    def mostrar_mensaje(self, mensaje, color):
        self.result_label.setText(mensaje)
        self.result_label.setStyleSheet(f"color: {color}; font-size: 10pt; font-weight: bold;")


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_Form_Datafono()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec())
