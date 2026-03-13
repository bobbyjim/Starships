from component import Component

class JumpDrive(Component):
   def __init__(self):
      super(JumpDrive,self).__init__()
      self.group = 'Driv'
      self.type = 'Jump Drive'
      self.code = 'J'
      self.rating = 1

   def update(self, hull):
      self.tons = int(5 + hull.tons * self.rating * 2.5/100.0)
      self.mcr = self.getCost()

   def getTons(self):
      return self.tons

   def getCost(self):
      return self.tons

   def updateDump(self, hull, selected):
      if self.rating > 0:
         self.update(hull)
         return super(JumpDrive, self).dump(selected)
