#!/usr/bin/env python3
from cmd2 import Cmd
from cmd2 import with_argument_list
import yaml
import sys
import re

from jumpdrive import JumpDrive
from maneuverdrive import ManeuverDrive
from hull import Hull
from worldWeapons import WorldWeapon
from spaceWeapons import SpaceWeapon
from worldSensors import WorldSensor
from spaceSensors import SpaceSensor
from componentfactory import ComponentFactory

volmap = {
   'A':  100, 'B':  200, 'C':  300, 'D':  400, 'E':  500, 'F':  600,
   'G':  700, 'H':  800, 'J':  900, 'K': 1000, 'L': 1100, 'M': 1200,
   'N': 1300, 'P': 1400, 'Q': 1500, 'R': 1600, 'S': 1700, 'T': 1800,
   'U': 1900, 'V': 2000, 'W': 2100, 'X': 2200, 'Y': 2300, 'Z': 2400
}

hull = Hull()
jump = JumpDrive()
manu = ManeuverDrive()

ship = {
   'mission': 'A',
   'hull': hull,
   'components': {
      jump.id: jump,
      manu.id: manu
   }
}

class Starshell(Cmd):
   intro = 'Welcome to Starshell. Type help or ? to list commands.\n' 
   prompt = 'stsh % '

   def __init__(self):
      super(Starshell,self).__init__()
      self.selected = None

   #################################################################
   #
   # Shipyard methods
   #
   #################################################################
   def do_hull(self,arg):
      'USAGE: hull <tons>. Creates a hull with the given volume.'
      self.do_tons(arg)

   def do_select(self, arg): 
      'USAGE: limu <component>. Selects a component for modification.'
      if ship[ 'components'][ arg ]:
         self.selected = arg
         print("Selected %s" % ship[ 'components'][ self.selected ].group)

   def do_qrebs(self,arg):
      'USAGE: qrebs <q|r|e|b|s|f> <-5 to 5>. Sets quality for selected component.'
      comp = ship[ 'components'][ self.selected ]
      print( comp.setQuality(arg) )

   def do_mount(self,arg):
      'USAGE: mount <surf|bolt|ant|bant|ext|t1|t2|t3|t4|b1|b2|bay|lbay|main> [d]. Sets mount type for selected sensor or weapon.'
      comp = ship[ 'components'][ self.selected ]
      print( comp.setMount(arg) )

   def do_stage(self,arg):
      'USAGE: stage <exp|pro|ear|std|imp|mod|adv|ult|obs>. Sets stage for selected component.'
      comp = ship[ 'components'][ self.selected ]
      print( comp.setStage(arg) )

   def do_range(self,arg):
      'USAGE: range <b or 0-12>. Sets appropriate range for selected sensor or weapon.'
      comp = ship[ 'components'][ self.selected ]
      print( comp.setRange(arg) )

   def do_tl(self, arg):
      'USAGE: tl 8-33, or tl 8-Z. Sets the TL (8-33 or use eHex).'
      comp = ship[ 'components' ].get( self.selected, 'None' )
      if comp == None:
         hull.setTL( arg )
         print("Ship TL set to %s" % hull.tl)
      else:
         print( comp.setTL( arg ) )

   def do_qsp(self, arg):
      'USAGE: qsp <M-HCMJ-T>. Sets the QSP (mission-hull-cfg-m-j-TL).'
      args = list(arg.upper())

      self.do_mission(args[0])
      self.do_tons(args[2])
      self.do_config(args[3])
      self.do_tl(args[7]) # do TL before M and J!
      
      self.do_m(args[4])
      self.do_j(args[5])

   def do_mission(self, arg): 
      'USAGE: girzi <A-Z>. Set the mission code.'
      ship.mission = arg

   def do_tons(self, arg):
      'USAGE: zim <tons>. Sets the hull tonnage.'
      if arg:
         if arg.isalpha(): # i.e. a volume code
            hull.tons = volmap[ arg ]
         else:             # assume it's a number
            hull.tons = int(arg)
         print("%s tons" % arg)

   def do_config(self, arg): 
      'USAGE: urgikiim C|B|P|U|S|A|L.  Sets the hull configuration type.'
      if arg:
         hull.setConfig(arg)
         print("%s tons, config %s" % (hull.tons, hull.getConfig()))

   def do_m(self, arg):
      'USAGE: m 0-9. Sets the Maneuver drive rating (1-9).'
      manu.rating = int(arg)
      manu.tl = hull.tl
      print("Maneuver Rating: %sG" % manu.rating)
      self.selected = manu.id

   def do_j(self, arg):
      'USAGE: j 0-9. Sets the Jump drive rating (1-9).'
      jump.rating = int(arg)
      jump.tl = hull.tl
      print("Jump Rating: J%s" % jump.rating)
      self.selected = jump.id

   def do_world(self,arg):
      if arg == 'sensor':
         self.do_world_sensor(arg)
      else:
         self.do_world_weapon(arg)

   def do_space(self,arg):
      if arg == 'sensor':
         self.do_space_sensor(arg)
      else:
         self.do_space_weapon(arg)

   def do_world_weapon(self,arg):
      'Adds a world-ranged weapon.'
      item = WorldWeapon()
      item.configure()
      if item.id:
         ship[ 'components'] [ item.id ] = item
         self.selected = item.id

   def do_space_weapon(self,arg):
      'Adds a space-ranged weapon.'
      item = SpaceWeapon()
      item.configure()
      if item.id:
         ship[ 'components'] [ item.id ] = item
         self.selected = item.id

   def do_world_sensor(self,arg):
      'Adds a world-ranged sensor.'
      item = WorldSensor()
      item.configure()
      if item.id:
         ship[ 'components'] [ item.id ] = item
         self.selected = item.id

   def do_space_sensor(self,arg):
      'Adds a space-ranged sensor.'
      item = SpaceSensor()
      item.configure()
      if item.id:
         ship[ 'components'] [ item.id ] = item
         self.selected = item.id

   def do_show(self, arg): 
      'USAGE: sii. Show the ship design so far.'
      print('Components:')
      hull.update()
      print('#  ID     Grp   C R No. TL QREBSf C Tons  MCr Label')
      print(' - ' + hull.id + ship['hull'].dump(self.selected))
      for id in ship[ 'components'] :
         print(' - ' + id + ship['components'][id].updateDump(hull,self.selected))


#   @with_argument_list
#   def do_wx(self, arglist):
#      'USAGE: wx amr bmr cmr ...  Weapon extension. Sets multiple weapons, in the form <code><mount><range>.'

#   @with_argument_list
#   def do_sx(self, arglist):
#      'USAGE: sx amr bnr cmr ... Sensor extension. Sets multiple sensors, in the form <code><mount><range>.'

   @with_argument_list
   def do_a(self, args):
      'Add a component in long form. USAGE: a <group> <code> <rating> <tons> <no.> <mcr> <tl> <QREBSf> <CP> [<Stage>] [<Range>] [<Mount>] [...(rest ignored)]'
      #for i,item in enumerate(args):
      #   print( "%d: %s" % (i, args[i]) )

      group      = args[0]
      code       = args[1]
      rating = int(args[2])
      tons   = int(args[3])
      count  = int(args[4])
      mcr  = float(args[5])
      tl         = args[6]
      qrebsf     = args[7]
      cp         = args[8]
      stage = ''
      range = ''
      mount = ''

      # stage, range, mount
      i = 9
      if len(args) > i:
         next = args[i] 
         if re.match( '^Exp|Pro|Ear|Std|Imp|Mod|Adv|Ult|Obs$', next ): # Stage
            stage = next
            i = i + 1

      if len(args) > i:
         next = args[i]
         if re.match( '^L|D|Vd|Or|Fo|G$', next ): # World Range
            range = next
            i = i + 1
         elif re.match( '^FR|SR|AR|LR|DS$', next): # Space Range
            range = next
            i = i + 1
     
      if len(args) > i:
         next = args[i]
         if re.match( '^Surf|Ant|Bant|Ext|T1|T2|T3|T4|B1|B2|Bay|LBay|M$', next): # Mount
            mount = next

      factory = ComponentFactory()
      item = factory.create(group,code,rating,tons,count,mcr,tl,qrebsf,cp,stage,range,mount)
      if item.id:
         ship[ 'components'] [ item.id ] = item
         print('item added')

   @with_argument_list
   def do_add(self,args):
      '"Short" import. USAGE: add <group> <code> [<stage>] [<range>] [<mount>]'
      
      group      = args[0]
      code       = args[1]
      rating     = 1
      tons       = 0
      count      = 1
      mcr        = 0.0
      tl         = str(hull.tl)
      qrebsf     = '000000'
      cp         = '1'
      stage      = ''
      range      = ''
      mount      = ''

      # stage, range, mount
      i = 2
      if len(args) > i:
         next = args[i]
         if re.match( '^Exp|Pro|Ear|Std|Imp|Mod|Adv|Ult|Obs$', next ): # Stage
            stage = next
            i = i + 1

      if len(args) > i:
         next = args[i]
         if re.match( '^L|D|Vd|Or|Fo|G$', next ): # World Range
            range = next
            i = i + 1
         elif re.match( '^FR|SR|AR|LR|DS$', next): # Space Range
            range = next
            i = i + 1
    
      if len(args) > i:
         next = args[i]
         if re.match( '^Surf|Ant|Bant|Ext|T1|T2|T3|T4|B1|B2|Bay|LBay|M$', next): # Mount
            mount = next

      factory = ComponentFactory()
      item = factory.create(group,code,rating,tons,count,mcr,tl,qrebsf,cp,stage,range,mount)
      if item.id:
         ship[ 'components'] [ item.id ] = item
         print('item added')

   #################################################################
   #
   # Utils
   #
   #################################################################
   def precmd(self, line):
      #print('selected: %s' % self.selected)
      return line

   def postcmd(self, stop, line):
      # Post-calculations!  And lots of them!
      return stop

   def do_save(self,arg):
      'Save the design in native importable format.'
      filename = arg + '.acs'
      self.selected = ' '
      with open(filename, 'w') as outfile:
         outfile.write('Components:\n')
         outfile.write(' a ' + ship['hull'].dump(self.selected) + "\n")
         for id in ship[ 'components'] :
            outfile.write(' a ' + ship['components'][id].updateDump(hull,self.selected) + "\n")
         outfile.close()
         print("%s written." % filename)

   def do_yaml(self, arg):
      'Save the design in a YAML-lite format.'
      filename = arg + '.yml'
      self.selected = ' '
      with open(filename, 'w') as outfile:
         outfile.write('Components:\n')
         outfile.write(' - ' + ship['hull'].dump(self.selected) + "\n")
         for id in ship[ 'components'] :
            outfile.write(' - ' + ship['components'][id].updateDump(hull,self.selected) + "\n")
         outfile.close()
         print("%s written." % filename)

   def do_bye(self, arg):
      exit(0)

Starshell().cmdloop()
