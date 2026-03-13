# cli-shipyard

A Traveller5 Adventure-Class-Starship builder in a CLI.  Currently 100% Python.  Planned to have a 'mirror' executable in Perl6, with both driven by the same source data in YAML files.

## Requirements

Currently, all you need is Python3.

## Source Data

The source data are six YAML files taken directly from my Flex (Flash/AS3) ACS builder, created several years ago.  They are:


acs-defenses.yml     - sensors, weapons, defenses, armor, coatings, and computers

acs-dispositions.yml - catalogs, shipbuilders, ship dispositions

acs-drives.yml       - drive types and fuel systems

acs-hulls.yml        - hull codes, costs, fittings, wings, landers, etc

acs-payload.yml      - living spaces and payloads

acs-vehicles.yml     - itemized list of vehicles

## Running

The entry program is named 'cli.py'.  Run it.

The Python CLI is built on top of the cmd2 package, which has useful ways to build out a CLI.

Enter 'help' to get a list of commands. Most commands have their own help text as well. For example, to get a short description of the 'yaml' command, type 'help yaml'.

### A Short Example

Here's a short transcript of a ship being created.

```
./cli.py
Welcome to Starshell. Type help or ? to list commands.

stsh % show
Components:
#  ID     Grp   C R No. TL QREBSf C Tons  MCr Label
 - NGJk   Hull  H 0   1  9 000000 0  200 14.0 Streamlined, 200 tons
 - YmU2   Driv  J 1   1  9 000000 0   10   10 Jump Drive
 - M2Q4   Driv  M 1   1  9 000000 0    2    4 Maneuver Drive
stsh % hull 400
400 tons
stsh % j 3
Jump Rating: J3
stsh % m 5
Maneuver Rating: 5G
stsh % space weapon
Select weapon type:
0: Empty
A: Particle Accelerator
C: CommCaster
G: Meson Gun
M: Missile
N: KK Missile
R: Rail Gun
V: Salvo Rack
X: AM Missile

weapon code> A
stsh % show
Components:
#  ID     Grp   C R No. TL QREBSf C Tons  MCr Label
 - NGJk   Hull  H 0   1  9 000000 0  400 26.0 Streamlined, 400 tons
 - YmU2   Driv  J 3   1  9 000000 0   35   35 Jump Drive
 - M2Q4   Driv  M 5   1  9 000000 0   19   38 Maneuver Drive
 - NTgx*  Swpn  A 1   1  9 000000 0    1  2.5 T1 Particle Accelerator
stsh % help yaml
Save the design in a YAML-lite format.
stsh % yaml testship
testship.yml written.
stsh % bye
```