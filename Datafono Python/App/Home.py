from PySide6 import QtCore, QtGui, QtWidgets
from validacion import ValidaciónVentana 

class Ui_MainWindow(QtWidgets.QMainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)

    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(780, 300)
        self.centralwidget = QtWidgets.QWidget(parent=MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.pushButton = QtWidgets.QPushButton(parent=self.centralwidget)
        self.pushButton.setGeometry(QtCore.QRect(310, 170, 131, 71))
        font = QtGui.QFont()
        font.setFamily("Yu Gothic UI Semilight")
        font.setBold(False)
        self.pushButton.setFont(font)
        self.pushButton.setText("Hacer un cobro")
        self.pushButton.setFlat(False)
        self.pushButton.setObjectName("pushButton")
        self.label = QtWidgets.QLabel(parent=self.centralwidget)
        self.label.setGeometry(QtCore.QRect(240, 40, 311, 81))
        self.label.setTextFormat(QtCore.Qt.TextFormat.AutoText)
        self.label.setAlignment(QtCore.Qt.AlignmentFlag.AlignCenter)
        self.label.setObjectName("label")
        self.label.setText(
            "<html><head/><body><p><span style=\" font-size:24pt; font-weight:700; color:#00007f;\">Datafono Bankify</span></p></body></html>"
        )
        MainWindow.setCentralWidget(self.centralwidget)
        self.menubar = QtWidgets.QMenuBar(parent=MainWindow)
        self.menubar.setGeometry(QtCore.QRect(0, 0, 800, 33))
        self.menubar.setObjectName("menubar")
        MainWindow.setMenuBar(self.menubar)
        self.statusbar = QtWidgets.QStatusBar(parent=MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.pushButton.clicked.connect(self.open_datafono)

    def open_datafono(self):
        try:
            self.datafono_window = ValidaciónVentana()
            self.datafono_window.show()
        except Exception as e:
            print(f"Error al abrir la ventana de Datafono: {e}")


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    main_window = Ui_MainWindow()
    main_window.show()
    sys.exit(app.exec())
