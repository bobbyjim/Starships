from component import Component
import yaml

class SpaceSensor(Component):
   def __init__(self):
      super(SpaceSensor,self).__init__()
      self.group = 'Ssen'
      self.rating = 1

   def setType(self,code):
      self.code = code
      sourcelist = self.datamanager.getSpaceSensorList()
      item = sourcelist.get(self.code)
      self.type = sourcelist.get(self.code).get('label', 'UNKNOWN')

   def list(self):
      sourcelist = self.datamanager.getSpaceSensorList()
      out = ''
      for code in sourcelist:
         out += "%s: %s\n" % (code, sourcelist[code]['label'])
      return out 

   def getItem(self,code):
      sourcelist = self.datamanager.getSpaceSensorList()
      return sourcelist.get(self.code, 'UNKNOWN')

   def setEntry(self,entry):
      self.type = entry[ 'label' ]
      self.mcr  = entry[ 'mcr' ]

   def configure(self):
      print('Select sensor type:')
      print(self.list())
      self.code = input('sensor code> ')
      entry = self.getItem( self.code )
      self.setEntry(entry)

   def updateDump(self, hull,selected):
      if self.rating > 0:
         return super(SpaceSensor, self).dump(selected)

