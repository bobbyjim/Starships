from component import Component

class ManeuverDrive(Component):
   def __init__(self):
      super(ManeuverDrive,self).__init__()
      self.group = 'Driv'
      self.type = 'Maneuver Drive'
      self.code = 'M'
      self.rating = 1

   def update(self, hull):
      self.tons = int(-1 + hull.tons * self.rating * 1/100.0)
      if self.tons == 1:
         self.tons = 2
      self.mcr = self.getCost()

   def getTons(self):
      return self.tons

   def getCost(self):
      return self.tons * 2

   def updateDump(self, hull,selected):
      if self.rating > 0:
         self.update(hull)
         return super(ManeuverDrive, self).dump(selected)
