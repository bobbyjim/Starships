from component import Component
import yaml

class WorldSensor(Component):
   def __init__(self):
      super(WorldSensor,self).__init__()
      self.group = 'Wsen'
      self.rating = 1

   def setType(self,code):
      self.code = code
      sourcelist = self.datamanager.getWorldSensorList()
      self.type = sourcelist.get(self.code).get('label', 'UNKNOWN')

   def list(self):
      sourcelist = self.datamanager.getWorldSensorList()
      out = ''
      for code in sourcelist:
         out += "%s: %s\n" % (code, sourcelist[code]['label'])
      return out 

   def getItem(self,code):
      sourcelist = self.datamanager.getWorldSensorList()
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
         return super(WorldSensor, self).dump(selected)

