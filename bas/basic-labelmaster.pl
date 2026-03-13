#!/usr/bin/env perl
use strict;
use warnings;

print STDERR "$0 v1.0\n";
# -----------------------------------------------------------
#
#  Labels are used as GOTO and GOSUB proxies.
#
# -----------------------------------------------------------
my %label    = ();

# -----------------------------------------------------------
#
#  Long variable names are declared like so:
#
#  longvar \mylongvariable ml
#
#  'longvar' is the keyword for declaring a long variable.
#  The long variable name comes next, prepended with a /.
#  After that comes the two-character BASIC 2.0 variable.
#  If not specified, its BASIC 2.0 mapping is automagic.  
#  This is the value that the long variable will be reduced 
#  to when the converter runs.
#
# -----------------------------------------------------------
#
#  Macros start with a dot.  For example:
#
#  cls() 	maps to		? chr$(147)
#  home()	maps to		? chr$(19)
#
# -----------------------------------------------------------

my %long  = ();
my %short = ();
my $shortvar = 'A0'; # 'A0'-'Y9' = max 234 longvars
my %locals = ();
my $localvar = 'Z0'; # 'Z0'-'Z9' = max 36 local vars

my %cbmcodes = (
	'CLR'	=>	'\X93',
	'HOME'	=>	'\X13',
	'SWUC'	=>	'',
	'DISH'	=>	'',
	'RVON'	=>	'\X12',
	'RVOF'	=>	'\X92',
	'DOWN'	=>	'\X11',
	'UP'	=>	'\X91',
	'RGHT'  =>	'\X1D',
	'RIGHT' =>	'\X1D',
	'LEFT'	=>	'\X9D',
	'CBM-A'	=>	'°',
	'CBM-B'	=>	'¿',
	'CBM-C'	=>	'Œ',
	'CBM-D'	=>	'¬',
  	'CBM-E' =>	'±',
	'CBM-F'	=>	'»',
	'CBM-G'	=>	'¥',
	'CBM-H'	=>	'Ž',
	'CBM-M'	=>	'§',
	'CBM-R'	=>	'²',
	'CBM-S'	=>	'®',
  	'CBM-T' =>	'£',
	'CBM-V'	=>	'Ÿ',
	'CBM-X'	=>	'œ',
	'CBM-Y'	=>	'·',
	'CBM-Z'	=>	'­',
	'CBM-\+'	=>	'Š',
	'CBM-POUND' =>	'š',
);


my $file = shift || synopsis();               #
open IN, $file or die "Cannot open $file\n";  # Read our file.
my @lines = map {uc} <IN>;                    #
close IN;                                     #

my $lineNumber = 0;
my $step = 5;

# -----------------------------------------------------------
#
#   Analysis Phase
#
# -----------------------------------------------------------
my @newlines = ();
my $errors = 0;
my $parseLine = 0;
for my $line (@lines)
{
   # remove in-house comments
   $line =~ s/^;.*$//;

   # process "macros"
   $line =~ s/^\\CLS\(\)/?CHR\$(147)/;
   $line =~ s/\b\\CLS\(\)/?CHR\$(147)/;
   $line =~ s/^\\HOME\(\)/?CHR\$(19)/;
   $line =~ s/\b\\HOME\(\)/?CHR\$(19)/;
   $line =~ s/^\\ECHO\s*(.*)$/?\"$1\"/;

   foreach my $code (sort keys %cbmcodes)
   {
      my $val = $cbmcodes{$code};
      print STDERR "* NO CODE FOUND FOR {$code}!\n" unless defined $val;
      $line =~ s/\{$code\}/$val/g;
   }

   # remove REMs?
   #$line =~ s/REM.*$//i;

   # macro
   $line =~ s/pad\((.+?),(\d+)\)/left\$($1+"                    ",$2)/g;

   # handle printing a banked string
=pod
   if ($line =~ /print\s*(.+?)\s*,\s*(.+?)\s*,\s*(.+?)/)
   {
      print "Found ]print $1 $2 $3\n";
      my $bank    = $1;
      my $address = $2;
      my $counter = $3;
      my $construct = "$counter = 0\n"
                    . "poke \$9f61,$bank\n"
                    . "{:loop-$counter}\n"
                    . "? chr$(peek($address+$counter));\n"
                    . "$counter = $counter + 1\n"
                    . "if peek($address+$counter) > 0 goto {:loop-$counter}\n";
      $line =~ s#\]print\s*$1\s*,\s*$2\s*,\s*$3#$construct#; 
   }
=cut

   # handle longvar declaration
   if ($line =~ /longvar\s+\\([\w\.-]+)[\$\%]?\s*(\w+)?/i)
   {
      my $longvarname = $1;
      my $basicvarname = $2;
      if (! $basicvarname)
      {
         $basicvarname = $shortvar;
         print STDERR "   $shortvar      (auto-gen)      \\$longvarname\n";
         $shortvar++;
      }

      if ($long{$longvarname})
      {
         print STDERR "Line $parseLine: Long varname '$longvarname' already declared!\n";
         $errors++;
      }
      if ($short{$basicvarname})
      {
         print STDERR "Line $parseLine: Short varname '$basicvarname' already mapped to $short{$basicvarname}!\n";
         $errors++;
      }
      $long{$longvarname} = $basicvarname;
      $short{$basicvarname} = $longvarname;
      $line = "";
   }

   foreach my $lv (keys %long)
   {
      if ($line =~ /\\$lv/i)   # handle longvar 
      {
         my $basic = $long{ $lv };

#        printf STDERR "BEFORE: %20s", $line;
         $line =~ s/\\$lv/$basic/g;
#        printf STDERR "AFTER : %20s", $line;
      }
#      else
#      {
#         print STDERR "Line $parseLine: UNDECLARED LONG VAR ($1)\n";
#         print STDERR "Line: $line\n";
#         $errors++;
#      }
   }

#   $line =~ s/\$\$//g;

   $lineNumber += $step;
   if ( $line =~ /^\s*(\{:[-\w\s.]+\})/ )        # Find a label:
   {
      my $lbl = $1;
      $label{ $lbl } = $lineNumber;              # Map label to line number
      $line =~ s/$1\s*//i;                       # Remove label decl
   }
   $lineNumber -= $step unless $line =~ /\S/;
   $parseLine++;

   push @newlines, $line if $line =~ /\S/;    # Remove empty lines
}
@lines = @newlines;

print STDERR "\nLabel Dump:\n" if keys %label > 0;
foreach (sort keys %label)
{
   print STDERR sprintf "    %-24s: $label{$_}\n", $_;
}
print STDERR "\n";
print STDERR "\nLongvar Dump:\n" if keys %long > 0;
foreach (sort keys %long)
{
   print STDERR sprintf "   \\%-24s: $long{$_}\n", $_;
}


die if $errors;
print STDERR "\nParse OK\n";

# -----------------------------------------------------------
#
#   Output Phase
#
# -----------------------------------------------------------
$lineNumber = 0;

#if ($lines[0] =~ /version ([\d\.]*)/i)  # first line have a version?
#{
#   my $oldver = $1;
#   my $newver = $oldver++;
#   $lines[0] =~ s/version $oldver/version: $newver/i;
#}

print STDERR "\nLabel conversion:\n" if keys %label;
for my $line (@lines)
{
   $lineNumber += $step;
   my @captures = $line =~ /(\{:[.\s\w-]+\})/g;

   foreach my $lbl (@captures)
   { 
      $lbl = $lbl;
      print STDERR "   - $lbl does not exist!\n" unless $label{$lbl};
      print STDERR "   - OK $lbl\n" if $label{$lbl};

      $line =~ s/$lbl/$label{$lbl}/g            # Replace label with line number
         if $label{$lbl};
   } 
   print "$lineNumber $line";              # Print our prepared line
}


sub synopsis
{
   print<<EOUSAGE;
USAGE: $0 basic-file

This program manipulates BASIC text in these ways:

1. It substitutes "?chr$(147)" for "cls()" and "?chr$(19)" for "home()".
2. It treats the semicolon (;) at column 1 ONLY as a REM shorthand.
3. It removes all blank lines.
4. It processes labels like so:

{:mylabel} print "hello, world"
goto {:mylabel}

   Labels are NOT case sensitive.
   Note that labels can contain dots and dashes.  So this works:

   goto {:BankUtil.parseString}

   ...but I don't handle parameters :(

5. It creates line numbers magically.
6. It manages declaration of STATES like so:

   my \$\$fu
   my \$\$fu = 12

7. It ENFORCES clear use of DECLARED STATES.
8. It manages long variables like so:
   longvar \\mylongvariablename 

   - the "long var" is mapped to an ascending alpha+numeric BASIC 2 variable.
   - it is type agnostic.  It only registers a string mapping.

EOUSAGE
}

