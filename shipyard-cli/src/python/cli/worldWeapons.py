from component import Component
import yaml

class WorldWeapon(Component):
   def __init__(self):
      super(WorldWeapon,self).__init__()
      self.group = 'Wwpn'
      self.rating = 1

   def setType(self,code):
      self.code = code
      sourcelist = self.datamanager.getWorldWeaponList()
      self.type = sourcelist.get(self.code).get('label', 'UNKNOWN')

   def list(self):
      sourcelist = self.datamanager.getWorldWeaponList()
      out = ''
      for code in sourcelist:
         out += "%s: %s\n" % (code, sourcelist[code]['label'])
      return out 

   def getItem(self,code):
      sourcelist = self.datamanager.getWorldWeaponList()
      return sourcelist.get(self.code, 'UNKNOWN')

   def setEntry(self,entry):
      self.type = entry[ 'label' ]
      self.mcr  = entry[ 'mcr' ]
      self.type = entry[ 'label' ]
      self.mount = 'T1'
      self.tons = 1

   def configure(self):
      print('Select weapon type:')
      print(self.list())
      self.code = input('weapon code> ')
      entry = self.getItem( self.code )
      self.setEntry(entry)

   def updateDump(self, hull,selected):
      if self.rating > 0:
         return super(WorldWeapon, self).dump(selected)

