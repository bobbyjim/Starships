from PyQt5.QtCore import Qt
from PyQt5.QtGui import QStandardItemModel, QStandardItem
from PyQt5.QtWidgets import QApplication, QMainWindow, QTableView

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()
        
    def initUI(self):
        # Create the model
        model = QStandardItemModel(4, 4)
        model.setHorizontalHeaderLabels(['Name', 'Age', 'Gender', 'Country'])
        
        # Add some data to the model
        model.setItem(0, 0, QStandardItem('John'))
        model.setItem(0, 1, QStandardItem('24'))
        model.setItem(0, 2, QStandardItem('Male'))
        model.setItem(0, 3, QStandardItem('USA'))
        
        # Create the table view
        tableView = QTableView()
        tableView.setModel(model)
        
        # Set the table view as the central widget
        self.setCentralWidget(tableView)

app = QApplication([])
window = MainWindow()
window.show()
app.exec_()