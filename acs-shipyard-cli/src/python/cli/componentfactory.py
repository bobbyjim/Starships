from jumpdrive import JumpDrive
from maneuverdrive import ManeuverDrive
from worldSensors import WorldSensor
from worldWeapons import WorldWeapon
from spaceSensors import SpaceSensor
from spaceWeapons import SpaceWeapon

class ComponentFactory:
   def create(self,group,code,rating,tons,count,mcr,tl,qrebsf,cp,stage,range,mount):
    
      obj = None
      if group == 'Driv':
         if code == 'M':
            obj = ManeuverDrive()
         elif code == 'J':
            obj = JumpDrive()
      elif group == 'Wsen':
         obj = WorldSensor()
         obj.setType(code)
      elif group == 'Ssen': 
         obj = SpaceSensor()
         obj.setType(code)
      elif group == 'Wwpn':
         obj = WorldWeapon()
         obj.setType(code)
      elif group == 'Swpn':
         obj = SpaceWeapon()
         obj.setType(code)
      else:
         obj = None

      if obj is not None:
         obj.rating = rating
         obj.tons = tons
         obj.count = count
         obj.mcr = mcr
         obj.setTL(tl)
         obj.setQrebs(qrebsf)
         obj.cp = cp
         obj.stage = stage
         obj.range = range
         obj.mount = mount

      return obj
