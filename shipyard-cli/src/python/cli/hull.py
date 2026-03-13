from component import Component
import yaml

stream = open( 'acs-hulls.yml' )
loaded = yaml.load(stream)
hulls = loaded.get('hulls', None)
if hulls is None:
   print("ERROR reading hulls from acs-hulls.yml. Aborting.")
   exit()

sourcelist = hulls.get('missions', None)
if sourcelist is None:
   print("ERROR reading subgroup hull missions from acs-hulls.yml. Aborting.")
   exit()

cfgmap = {
   'P': { 'scale': 0.01, 'add': 0, 'label': 'Planetoid' },
   'C': { 'scale': 0.02, 'add': 0, 'label': 'Cluster' },
   'B': { 'scale': 0.03, 'add': 0, 'label': 'Braced' },
   'U': { 'scale': 0.03, 'add': 2, 'label': 'Unstreamlined' },
   'S': { 'scale': 0.06, 'add': 2, 'label': 'Streamlined' },
   'A': { 'scale': 0.07, 'add': 2, 'label': 'Airframe' },
   'L': { 'scale': 0.12, 'add': 4, 'label': 'Liftbody' }
}

class Hull(Component):
   def __init__(self):
      super(Hull,self).__init__()
      self.group = 'Hull'
      self.code  = 'H'
      self.config = 'S'
      self.configLabel = cfgmap[ self.config ][ 'label' ]
      self.type  = 'Hull'
      self.tons  = 200

   def setConfig(self, arg):
      self.config = arg
      self.configLabel = cfgmap[ self.config ][ 'label' ]

   def getConfig(self):
      return self.config

   def update(self):
      if self.code is not None and self.tons is not None:
         self.mcr = self.tons * cfgmap[ self.config ][ 'scale' ] + cfgmap[ self.config ][ 'add' ]

   def description(self):
      return "%s, %s tons" % (self.configLabel, self.tons)

   def dump(self,selected):
      return super(Hull, self).dump(selected)

   #def dump(self):      # gp co ra no. TL  QQQ cp vol mcr desc
   #   return ' -        %-5s %s %s %3d %2d %6s %d %4d %4d %s' % \
   #         (self.group, self.code, '1', self.count, self.tl, '     ', self.cp, self.tons, self.mcr, self.description())

