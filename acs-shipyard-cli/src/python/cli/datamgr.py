################################################################################
#
#  Curates the configuration data.
#
################################################################################
import yaml

class DataManager:
   def __init__(self):
      stream = open( 'acs-defenses.yml' )
      self.defenses = yaml.load(stream)
      stream = open( 'acs-hulls.yml' )
      self.hulls = yaml.load(stream)

   def getWorldSensorList(self):
      return self.getDefenseList('sensors', 'world')

   def getSpaceSensorList(self):
      return self.getDefenseList('sensors', 'space')

   def getWorldWeaponList(self):
      return self.getDefenseList('weapons', 'world')

   def getSpaceWeaponList(self):
      return self.getDefenseList('weapons', 'space')

   def getDefenseList(self, type, subtype):
      defdict = self.defenses.get(type, None)
      if defdict is None:
         print("ERROR getting %s from acs-defenses.yml. Aborting." % type)
         exit()

      sourcelist = defdict.get(subtype, None)
      if sourcelist is None:
         print("ERROR reading subgroup %s %s from acs-defenses.yml. Aborting." % (type, subtype))
         exit() 

      return sourcelist

