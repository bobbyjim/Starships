from PyQt5.QtCore import Qt
from PyQt5.QtWidgets import QListWidget, QApplication, QMainWindow, QListWidgetItem

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.initUI()
        
    def initUI(self):
        self.listWidget = QListWidget(self)
        self.setCentralWidget(self.listWidget)
        
        # Enable drag and drop
        self.listWidget.setDragDropMode(QListWidget.InternalMove)
        
        # Add some items to the list widget
        items = ['Item 1', 'Item 2', 'Item 3']
        for item in items:
            self.listWidget.addItem(QListWidgetItem(item))

app = QApplication([])
window = MainWindow()
window.show()
app.exec_()
