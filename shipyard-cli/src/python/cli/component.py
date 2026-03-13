import uuid
import base64
from datamgr import DataManager

tlmap = { '0':  0, '1':  1, '2':  2, '3':  3, '4':  4, '5':  5,
          '6':  6, '7':  7, '8':  8, '9':  9, 'A': 10, 'B': 11, 
          'C': 12, 'D': 13, 'E': 14, 'F': 15, 'G': 16, 'H': 17,
          'J': 18, 'K': 19, 'L': 20, 'M': 21, 'N': 22, 'P': 23,
          'Q': 24, 'R': 25, 'S': 26, 'T': 27, 'U': 28, 'V': 29,
          'W': 30, 'X': 31, 'Y': 32, 'Z': 33
}

def genid():
   return base64.b64encode(str(uuid.uuid4()).encode()).decode()[:4]
   # in 2.7: base64.b64encode(uuid.uuid4().bytes[:4])

datamanager = DataManager()

class Component(object):
   def __init__(self):
      self.datamanager = datamanager
      self.id = genid()
      self.group = 'None'
      self.code = ''
      self.rating = 0
      self.tons = 0
      self.count = 1
      self.mcr = 0
      self.tl = 9
      self.qrebsf = {
         'q': 0,
         'r': 0,
         'e': 0,
         'b': 0,
         's': 0,
         'f': 0 # efficiency
      }
      self.cp = 0
      self.stage = ''
      self.range = ''
      self.mount = ''
      self.type = ''
      self.letter = ''

   def qualify(self, item):
      values = [ 'E', 'D', 'C', 'B', 'A', '0', '1', '2', '3', '4', '5' ]
      return values[ item + 5 ]

   def qrebs_decode(self, item):
      values = { 'E': -5, 'D': -4, 'C': -3, 'B': -2, 'A': -1, '0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5 }
      return values.get(item, 0)

   def setTL(self, tlchar):
      if tlchar.isalpha():
         self.tl = tlmap[ tlchar ]
      else:
         self.tl = int(tlchar)
      return "TL set to %d" % self.tl

   def setQuality(self,arg):
      chunks = arg.split()
      q = chunks[0]      # 'q' 'r' 'e' 'b' 's' or 'f'
      v = int(chunks[1]) # -5 to 5
      self.qrebsf[ q ] = v
      return "%s set to %d" % (q,v)

   def setMount(self,mount):
      self.mount = mount
      return "mount set to %s" % self.mount

   def setStage(self,stage):
      self.stage = stage
      return "stage set to %s" % self.stage

   def setRange(self,range):
      self.range = range
      return "range set to %s" % self.range

   def setQrebs(self,qrebsf):
      chunk = qrebsf
      self.qrebsf = {
         'q': self.qrebs_decode(chunk[0]),
         'r': self.qrebs_decode(chunk[1]),
         'e': self.qrebs_decode(chunk[2]),
         'b': self.qrebs_decode(chunk[3]),
         's': self.qrebs_decode(chunk[4]),
         'f': self.qrebs_decode(chunk[5])
      }
   def getQrebs(self):
      return self.qualify(self.qrebsf['q']) + self.qualify(self.qrebsf['r']) + self.qualify(self.qrebsf['e']) + self.qualify(self.qrebsf['b']) + self.qualify(self.qrebsf['s']) + self.qualify(self.qrebsf['f'])
    
   def description(self):
      out = self.stage 
      out += ' ' if self.stage != '' else ''
      out += self.range 
      out += ' ' if self.range != '' else ''
      mount = self.mount
      out += mount
      out += ' ' if mount != '' else ''
      out += self.type
      return out

   def dump(self,selected):
      sel = ' '
      if self.id == selected:
         sel = '*'
      sel += ' '
      #       **  grp co ra no. TL  QQQ Cp vol mcr desc
      return '%s %-5s %s %s %3d %2d %6s %s %4s %4s %s' % \
            (sel, self.group, self.code, self.rating, self.count, self.tl, self.getQrebs(), self.cp, self.tons, self.mcr, self.description())

