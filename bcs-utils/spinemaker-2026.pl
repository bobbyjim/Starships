use strict;

my %damageTable = (
   A => 1, B => 2, C => 3, D => 4, E => 5, F => 6,
   G => 7, H => 8, J => 9, K => 10, L => 11, M => 12,
   N => 13, P => 14, Q => 15, R => 16, S => 17, T => 18,
   U => 19, V => 20, W => 21, X => 22, Y => 23, Z => 24, 'Z+' => 25
);

my @damageCode = sort keys %damageTable;

=pod
CODE  A  B  C  D  E  F  G  H  J  K  L  M  N  O  P  Q  R  S  T
--------------------------------------------------------------
HITS  1  2  3  4  5  6  7  8  9  10 11 12 13 14 15 16 17 18 19
=cut

my %bulk = (   # vol  code
   VLight   => [ 0.5, -5 ],
   Light    => [ 0.8, -3 ],
   Medium   => [ 1, 0 ],
   Heavy    => [ 1.6, 2 ],
   VHeavy   => [ 2.0, 4 ],
);

my @bulks = qw/VLight Light Medium Heavy VHeavy/;

my %stage = (
               # TL  code  vol
   Proto    => [ -2, -5,    1  ],
   Early    => [ -1, -3,    1  ],
   Standard => [ 0,   0,    1  ],
   Improved => [ 1,   2,    1  ],
   Modified => [ 2,   4,    1  ],
   Advanced => [ 3,   6,    1  ],
   Ultimate => [ 4,   8,    1  ],
);

my @stages = qw/Proto Early Standard Improved Modified Advanced Ultimate/; 

calculateSpinesForClass( 'PA Spine',    11, 4000, 'H' );
calculateSpinesForClass( 'Meson Spine', 13, 5000, 'L' );
calculateSpinesForClass( 'Inducer',     17, 6000, 'G' );
calculateSpinesForClass( 'Disruptor',   18, 4000, 'K' );
calculateSpinesForClass( 'Stasis',      21, 4500, 'N' );

sub calculateSpinesForClass
{
   my $label    = shift;
   my $baseTL   = shift;
   my $baseVol  = shift;
   my $baseCode = shift;

   print "Spine Type-TL                      Code (damage)  Tons\n";
   print "---------------------------------  -------------  -----\n";
   foreach my $stage (@stages) 
   {
      foreach my $bulk (@bulks)
      {
         print calculateSpine( $label, $baseTL, $baseVol, $baseCode, $stage, $stage{ $stage }, $bulk, $bulk{ $bulk } );
      }
      print "\n";
   }
}

sub calculateSpine
{
   my $label     = shift;
   my $baseTL    = shift;
   my $baseVol   = shift;
   my $baseCode  = shift;
   my $stageLabel = shift;
   my $stageRef  = shift;
   my $bulkLabel = shift;
   my $bulkRef   = shift;

   my $baseDamage = $damageTable{ $baseCode };
   my $index      = $baseDamage; #  - 10; # hack

   $baseTL += $stageRef->[ 0 ];  # adjust TL
   $index  += $stageRef->[ 1 ];  # adjust damage code
   $baseVol *= $stageRef->[ 2 ]; # in case we decide to do this

   $baseVol *= $bulkRef->[ 0 ]; 
   $index   += $bulkRef->[ 1 ];

   $baseCode = $damageCode[ $index ];
   $baseCode = 'Z+' unless $baseCode;

   $label = sprintf "%8s %8s %s", $stageLabel,$bulkLabel,"$label-$baseTL";

   return "" if $index < 0;
   return sprintf "%-33s    %2s (%d)      %5d\n", $label, $baseCode, $damageTable{$baseCode}, $baseVol;
}

