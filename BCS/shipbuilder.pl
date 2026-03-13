#!/usr/bin/env perl
use strict;
use warnings;

=head1 NAME

shipbuilder.pl - Traveller 5 BCS Starship Designer

=head1 SYNOPSIS

    perl shipbuilder.pl --tonnage 50000 --spine-tonnage 5000 --armor 4 --jump 3 --maneuver 2 --tl 15

=head1 DESCRIPTION

This script takes primary ship parameters and calculates reasonable
secondary/tertiary weapons and defenses that fit within the specified tonnage.

=cut

use Getopt::Long;

# Spine weapon definitions from spinemaker-2026.pl
my %damageTable = (
   A => 1, B => 2, C => 3, D => 4, E => 5, F => 6,
   G => 7, H => 8, J => 9, K => 10, L => 11, M => 12,
   N => 13, P => 14, Q => 15, R => 16, S => 17, T => 18,
   U => 19, V => 20, W => 21, X => 22, Y => 23, Z => 24, 'Z+' => 25
);

my @damageCode = sort keys %damageTable;

my %bulk = (   # vol  code
   VLight   => [ 0.5, -5 ],
   Light    => [ 0.8, -3 ],
   Medium   => [ 1, 0 ],
   Heavy    => [ 1.6, 2 ],
   VHeavy   => [ 2.0, 4 ],
);

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

my %spine_types = (
   PA       => [ 11, 4000, 'H' ],
   Meson    => [ 13, 5000, 'L' ],
   Inducer  => [ 17, 6000, 'G' ],
   Disruptor => [ 18, 4000, 'K' ],
   Stasis   => [ 21, 4500, 'N' ],
);

# Parse command line arguments
my %opts = (
    name => 'Starship',
    spine_type => 'PA',
    spine_stage => 'Standard',
    spine_bulk => 'Medium',
    armor => 0,
    power => undef,  # defaults to maneuver if not specified
    offense => '',
    defense => '',
    qsp => '',
);

GetOptions(
    'name=s' => \$opts{name},
    'spine-type=s' => \$opts{spine_type},
    'spine-stage=s' => \$opts{spine_stage},
    'spine-bulk=s' => \$opts{spine_bulk},
    'armor=i' => \$opts{armor},
    'power=i' => \$opts{power},
    'offense=s' => \$opts{offense},
    'defense=s' => \$opts{defense},
    'qsp=s' => \$opts{qsp},
    'help' => \&usage,
) or usage();

# QSP is required - it defines the fundamental ship characteristics
usage("QSP (--qsp) is required") unless $opts{qsp};

# Parse QSP to get core ship characteristics
my $qsp_data = parse_qsp($opts{qsp});
$opts{mission} = $qsp_data->{mission};
$opts{tonnage} = $qsp_data->{tonnage};
$opts{hull_config} = $qsp_data->{hull_config};
$opts{maneuver} = $qsp_data->{maneuver};
$opts{jump} = $qsp_data->{jump};
$opts{hop} = $qsp_data->{hop};
$opts{tl} = $qsp_data->{tl};

# Parse offense string if provided (format: XYZ where X=secondary, Y=tertiary, Z=marines)
if ($opts{offense}) {
    unless ($opts{offense} =~ /^(\d)(\d)(\d)$/) {
        usage("Invalid offense format: $opts{offense}\nExpected format: XYZ (e.g., 987 for secondary=9, tertiary=8, marines=7)");
    }
    $opts{secondary_offense} = $1;
    $opts{tertiary_offense} = $2;
    $opts{marine_offense} = $3;
}

# Parse defense string if provided (format: XYZ where X=secondary, Y=tertiary, Z=marines)
if ($opts{defense}) {
    unless ($opts{defense} =~ /^(\d)(\d)(\d)$/) {
        usage("Invalid defense format: $opts{defense}\nExpected format: XYZ (e.g., 864 for secondary=8, tertiary=6, marines=4)");
    }
    $opts{secondary_defense} = $1;
    $opts{tertiary_defense} = $2;
    $opts{marine_defense} = $3;
}

# Validate inputs
usage() unless $opts{tonnage} > 0;
usage() unless $opts{spine_type};

# Validate spine parameters
usage("Invalid spine type: $opts{spine_type}") unless exists $spine_types{$opts{spine_type}};
usage("Invalid spine stage: $opts{spine_stage}") unless exists $stage{$opts{spine_stage}};
usage("Invalid spine bulk: $opts{spine_bulk}") unless exists $bulk{$opts{spine_bulk}};

# Calculate spine characteristics
my ($spine_tonnage, $spine_tl, $spine_damage) = calculate_spine(
    $opts{spine_type},
    $opts{spine_stage},
    $opts{spine_bulk}
);

# Default power to max of maneuver, jump, or hop if not specified
my @tmp_ratings = sort($opts{maneuver}, $opts{jump}, $opts{hop} // 0);
$opts{power} = $tmp_ratings[-1] unless defined $opts{power};

# Armor granularity: user inputs 0-45, internally uses 0-9
# Max armor is based on tech level: TL + 5
my $max_armor = $opts{tl} + 5;
my $display_armor = $opts{armor};
if ($display_armor > $max_armor) {
    print "WARNING: Armor $display_armor exceeds max for TL $opts{tl} (max: $max_armor). Reducing to $max_armor.\n\n";
    $display_armor = $max_armor;
}
my $internal_armor = int($display_armor / 5);

# Secondary and Tertiary tonnage tables
my @secondary_tonnage = (0, 100, 400, 1600, 4000, 8000, 14000, 20000, 28000, 40000);
my @tertiary_tonnage  = (0, 100, 200, 400,  800,  1200, 1800,  4000,  10000, 20000);

# Marines table
my @marine_tonnage    = (0, 100, 200, 400,  800,  1200, 1800, 4000, 5000,  6000,  15000);
my @marine_count      = (0, 19,  41,  80,   127,   160, 290,  450,  540,    640,    1500);

print "=" x 70, "\n";
print "TRAVELLER 5 BCS STARSHIP DESIGN\n";
print "=" x 70, "\n\n";

print "Input Parameters:\n";
print "  Mission: $opts{mission}\n" if $opts{mission};
print "  Hull Config: $opts{hull_config}\n" if $opts{hull_config};
print "  Total Tonnage: ", commify($opts{tonnage}), " tons\n";
print "  Tech Level: TL $opts{tl}\n";
print "  Spine Weapon: $opts{spine_stage} $opts{spine_bulk} $opts{spine_type} Spine-$spine_tl\n";
print "    Damage Code: $spine_damage\n";
print "    Tonnage: ", commify($spine_tonnage), " tons\n";
print "  Primary Armor Rating: $display_armor
";
print "  Jump: $opts{jump}\n";
print "  Hop: $opts{hop}\n" if $opts{hop};
print "  Maneuver: $opts{maneuver}\n";
print "  Power: $opts{power}\n\n";

# Calculate stage effects for TL
my $stage_mod = 0;
if ($opts{tl} >= 19 && $opts{tl} <= 21) {
    $stage_mod = 2;
} elsif ($opts{tl} >= 16 && $opts{tl} <= 18) {
    $stage_mod = 1;
} elsif ($opts{tl} >= 10 && $opts{tl} <= 12) {
    $stage_mod = -1;
}

print "-" x 70, "\n";
print "FIXED PAYLOAD\n";
print "-" x 70, "\n";
my $spine_payload = $spine_tonnage;
print "  Spine Weapon: ", commify($spine_payload), " tons\n\n";

# Calculate percentage systems
print "-" x 70, "\n";
print "PERCENTAGE SYSTEMS\n";
print "-" x 70, "\n";

my $bridge_pct = 2.0;
my $crew_pct = 6.0;
my $primary_defense_pct = $internal_armor * 4.0;
my $jump_pct = $opts{jump} * 2.5;
my $hop_pct = $opts{hop} * 2.5;
my $maneuver_pct = $opts{maneuver} * 1.0;
my $power_pct = $opts{power} * 1.5;

# Fuel percentages
my $jump_fuel_pct = $opts{jump} * 10.0;
my $hop_fuel_pct = $opts{hop} * 10.0;
my $power_fuel_pct = 0;
if ($opts{tl} >= 15) {
    $power_fuel_pct = $opts{power} * 1.0;
} elsif ($opts{tl} >= 13) {
    $power_fuel_pct = $opts{power} * 2.0;
} elsif ($opts{tl} >= 9) {
    $power_fuel_pct = $opts{power} * 3.0;
} else {
    $power_fuel_pct = $opts{power} * 4.0;
}

print "  Bridge: $bridge_pct%\n";
print "  Crew Life Support: $crew_pct%\n";
print "  Primary Defense (Armor $display_armor): $primary_defense_pct%\n";
print "  Jump Drive: $jump_pct%\n" if $opts{jump};
print "  Hop Drive: $hop_pct%\n" if $opts{hop};
print "  Maneuver Drive: $maneuver_pct%\n";
print "  Power Plant: $power_pct%\n";
print "  Jump Fuel: $jump_fuel_pct%\n" if $opts{jump};
print "  Hop Fuel: $hop_fuel_pct%\n" if $opts{hop};
print "  Power Fuel: $power_fuel_pct%\n";

my $total_pct = $bridge_pct + $crew_pct + $primary_defense_pct + 
                $jump_pct + $hop_pct + $maneuver_pct + $power_pct +
                $jump_fuel_pct + $hop_fuel_pct + $power_fuel_pct;

print "  SUBTOTAL: $total_pct%\n\n";

# Calculate available tonnage for variable payload
my $available_payload = $opts{tonnage} * (1 - $total_pct / 100.0) - $spine_payload;

print "-" x 70, "\n";
print "PAYLOAD BUDGET\n";
print "-" x 70, "\n";
print "  Available for secondaries/tertiaries/marines: ", commify(int($available_payload)), " tons\n\n";

if ($available_payload < 0) {
    die "ERROR: Ship is over-tonnage! Need to reduce requirements or increase total tonnage.\n";
}

# Now allocate the available payload intelligently
my %allocation;
my $auto_mode = !$opts{offense} && !$opts{defense};

if ($auto_mode) {
    %allocation = allocate_payload($available_payload, $opts{tl}, $stage_mod);
    print "  (Using automatic allocation)\n\n";
} else {
    # Manual mode - use specified values or defaults
    $allocation{secondary_offense} = $opts{secondary_offense} || 0;
    $allocation{secondary_defense} = $opts{secondary_defense} || 0;
    $allocation{tertiary_offense} = $opts{tertiary_offense} || 0;
    $allocation{tertiary_defense} = $opts{tertiary_defense} || 0;
    $allocation{marine_offense} = $opts{marine_offense} || 0;
    $allocation{marine_defense} = $opts{marine_defense} || 0;
    
    # Calculate tonnages
    $allocation{secondary_offense_tons} = $secondary_tonnage[$allocation{secondary_offense}] || 0;
    $allocation{secondary_defense_tons} = $secondary_tonnage[$allocation{secondary_defense}] || 0;
    $allocation{tertiary_offense_tons} = $tertiary_tonnage[$allocation{tertiary_offense}] || 0;
    $allocation{tertiary_defense_tons} = $tertiary_tonnage[$allocation{tertiary_defense}] || 0;
    $allocation{marine_offense_tons} = $marine_tonnage[$allocation{marine_offense}] || 0;
    $allocation{marine_offense_count} = $marine_count[$allocation{marine_offense}] || 0;
    $allocation{marine_defense_tons} = $marine_tonnage[$allocation{marine_defense}] || 0;
    $allocation{marine_defense_count} = $marine_count[$allocation{marine_defense}] || 0;
    
    print "  (Using manual specification)\n\n";
}

print "-" x 70, "\n";
print "RECOMMENDED ALLOCATION\n";
print "-" x 70, "\n";

print "\nSecondary Weapons:\n";
print "  Rating: $allocation{secondary_offense} (adjusted: ", $allocation{secondary_offense} + $stage_mod, ")\n";
print "  Tonnage: ", commify($allocation{secondary_offense_tons}), " tons\n";

print "\nSecondary Defenses (Screens/Repulsors):\n";
print "  Rating: $allocation{secondary_defense} (adjusted: ", $allocation{secondary_defense} + $stage_mod, ")\n";
print "  Tonnage: ", commify($allocation{secondary_defense_tons}), " tons\n";

print "\nTertiary Weapons:\n";
print "  Rating: $allocation{tertiary_offense} (adjusted: ", $allocation{tertiary_offense} + $stage_mod, ")\n";
print "  Tonnage: ", commify($allocation{tertiary_offense_tons}), " tons\n";

print "\nTertiary Defenses (Sandcasters):\n";
print "  Rating: $allocation{tertiary_defense} (adjusted: ", $allocation{tertiary_defense} + $stage_mod, ")\n";
print "  Tonnage: ", commify($allocation{tertiary_defense_tons}), " tons\n";

print "\nMarine Boarding Party (Offense):\n";
print "  Rating: $allocation{marine_offense}\n";
print "  Count: $allocation{marine_offense_count}\n";
print "  Tonnage: ", commify($allocation{marine_offense_tons}), " tons\n";

print "\nMarine Defense Force:\n";
print "  Rating: $allocation{marine_defense}\n";
print "  Count: $allocation{marine_defense_count}\n";
print "  Tonnage: ", commify($allocation{marine_defense_tons}), " tons\n";

my $total_allocated = $allocation{secondary_offense_tons} + 
                      $allocation{secondary_defense_tons} +
                      $allocation{tertiary_offense_tons} +
                      $allocation{tertiary_defense_tons} +
                      $allocation{marine_offense_tons} +
                      $allocation{marine_defense_tons};

print "\nTotal Variable Payload: ", commify($total_allocated), " tons\n";

my $unused = int($available_payload - $total_allocated);
if ($unused < 0) {
    print "OVER TONNAGE BY: ", commify(abs($unused)), " tons ***\n";
} else {
    print "Unused Payload: ", commify($unused), " tons\n";
}

# Final summary
print "\n", "=" x 70, "\n";
print "FINAL SUMMARY\n";
print "=" x 70, "\n";

my $total_payload = $spine_payload + $total_allocated;
my $percentage_systems_tons = int($opts{tonnage} * ($total_pct / 100.0));
my $grand_total = $spine_payload + $total_allocated + $percentage_systems_tons;

print "  Spine Payload: ", commify($spine_payload), " tons\n";
print "  Variable Payload: ", commify($total_allocated), " tons\n";
print "  Total Payload: ", commify($total_payload), " tons (", sprintf("%.1f", 100.0 * $total_payload / $opts{tonnage}), "%)\n";
print "  Percentage Systems: ", commify($percentage_systems_tons), " tons ($total_pct%)\n";
print "  Grand Total: ", commify($grand_total), " tons\n";

print "\n";

# Compact data block format
my $spine_prefix = '';
if ($opts{spine_type} eq 'PA') {
    $spine_prefix = '*';
} elsif ($opts{spine_type} eq 'Inducer') {
    $spine_prefix = '#';
} elsif ($opts{spine_type} eq 'Disruptor') {
    $spine_prefix = '+';
} elsif ($opts{spine_type} eq 'Stasis') {
    $spine_prefix = '^';
}
# Meson gets no prefix

# Get numeric spine damage value
my $spine_damage_numeric = $damageTable{$spine_damage} || 0;

my $tonnage_k = $opts{tonnage} / 1000;
my $designation = sprintf("%d-%d%d-TL%d", $tonnage_k, $opts{maneuver}, $opts{jump}, $opts{tl});

print "-" x 70, "\n";
print "$opts{name}  $designation\n";
print "     Offense: $spine_damage_numeric-";
print $allocation{secondary_offense};
print $allocation{tertiary_offense};
print $allocation{marine_offense};
print "\n";
print "     Defense: ";
print $display_armor;
print "-";
print $allocation{secondary_defense};
print $allocation{tertiary_defense};
print $allocation{marine_defense};
print "\n";
print "-" x 70, "\n";

print "\n";

# ============================================================================
# SUBROUTINES
# ============================================================================

sub calculate_spine {
    my ($type, $stage_label, $bulk_label) = @_;
    
    my $spine_ref = $spine_types{$type};
    my $baseTL = $spine_ref->[0];
    my $baseVol = $spine_ref->[1];
    my $baseCode = $spine_ref->[2];
    
    my $stageRef = $stage{$stage_label};
    my $bulkRef = $bulk{$bulk_label};
    
    my $baseDamage = $damageTable{$baseCode};
    my $index = $baseDamage;
    
    $baseTL += $stageRef->[0];  # adjust TL
    $index  += $stageRef->[1];  # adjust damage code
    $baseVol *= $stageRef->[2]; # volume modifier
    
    $baseVol *= $bulkRef->[0];  # bulk volume
    $index   += $bulkRef->[1];  # bulk damage
    
    $baseCode = $damageCode[$index];
    $baseCode = 'Z+' unless $baseCode;
    
    my $tonnage = int($baseVol);
    
    return ($tonnage, $baseTL, $baseCode);
}

sub allocate_payload {
    my ($available, $tl, $stage_mod) = @_;
    
    my %result;
    
    # Strategy: Allocate in priority order
    # 1. Tertiary defense (essential)
    # 2. Secondary defense (important)
    # 3. Secondary offense (major firepower)
    # 4. Tertiary offense (point defense)
    # 5. Marines (if room permits) - split between offense and defense
    
    my $remaining = $available;
    
    # Start with modest allocations and scale up based on available tonnage
    my $secondary_offense_rating = 1;
    my $secondary_defense_rating = 1;
    my $tertiary_offense_rating = 1;
    my $tertiary_defense_rating = 1;
    my $marine_offense_rating = 0;
    my $marine_defense_rating = 0;
    
    # Determine scale based on available tonnage
    if ($remaining >= 40000) {
        $secondary_offense_rating = 5;
        $secondary_defense_rating = 5;
        $tertiary_offense_rating = 5;
        $tertiary_defense_rating = 5;
    } elsif ($remaining >= 20000) {
        $secondary_offense_rating = 4;
        $secondary_defense_rating = 4;
        $tertiary_offense_rating = 4;
        $tertiary_defense_rating = 4;
    } elsif ($remaining >= 8000) {
        $secondary_offense_rating = 3;
        $secondary_defense_rating = 3;
        $tertiary_offense_rating = 3;
        $tertiary_defense_rating = 3;
    } elsif ($remaining >= 3000) {
        $secondary_offense_rating = 2;
        $secondary_defense_rating = 2;
        $tertiary_offense_rating = 2;
        $tertiary_defense_rating = 2;
    }
    
    # Calculate tonnages for initial ratings
    my $sec_off_tons = $secondary_tonnage[$secondary_offense_rating] || 0;
    my $sec_def_tons = $secondary_tonnage[$secondary_defense_rating] || 0;
    my $ter_off_tons = $tertiary_tonnage[$tertiary_offense_rating] || 0;
    my $ter_def_tons = $tertiary_tonnage[$tertiary_defense_rating] || 0;
    
    # Check if we need to scale down
    my $total_weapons = $sec_off_tons + $sec_def_tons + $ter_off_tons + $ter_def_tons;
    
    while ($total_weapons > $remaining * 0.9 && $secondary_offense_rating > 1) {
        $secondary_offense_rating--;
        $secondary_defense_rating--;
        $tertiary_offense_rating-- if $tertiary_offense_rating > 1;
        $tertiary_defense_rating-- if $tertiary_defense_rating > 1;
        
        $sec_off_tons = $secondary_tonnage[$secondary_offense_rating] || 0;
        $sec_def_tons = $secondary_tonnage[$secondary_defense_rating] || 0;
        $ter_off_tons = $tertiary_tonnage[$tertiary_offense_rating] || 0;
        $ter_def_tons = $tertiary_tonnage[$tertiary_defense_rating] || 0;
        $total_weapons = $sec_off_tons + $sec_def_tons + $ter_off_tons + $ter_def_tons;
    }
    
    # Allocate marines with remaining space
    # Cap marines at secondary rating + 1 (ships shouldn't be too lopsided)
    # Split remaining space roughly 40% offense / 60% defense
    my $max_marine_rating = $secondary_offense_rating + 1;
    $remaining -= $total_weapons;
    
    my $marine_offense_budget = int($remaining * 0.4);
    my $marine_defense_budget = $remaining - $marine_offense_budget;
    
    # Allocate marine offense
    for my $i (reverse 0 .. $#marine_tonnage) {
        if ($marine_tonnage[$i] <= $marine_offense_budget && $i <= $max_marine_rating) {
            $marine_offense_rating = $i;
            last;
        }
    }
    
    # Allocate marine defense
    for my $i (reverse 0 .. $#marine_tonnage) {
        if ($marine_tonnage[$i] <= $marine_defense_budget && $i <= $max_marine_rating) {
            $marine_defense_rating = $i;
            last;
        }
    }
    
    $result{secondary_offense} = $secondary_offense_rating;
    $result{secondary_offense_tons} = $sec_off_tons;
    $result{secondary_defense} = $secondary_defense_rating;
    $result{secondary_defense_tons} = $sec_def_tons;
    $result{tertiary_offense} = $tertiary_offense_rating;
    $result{tertiary_offense_tons} = $ter_off_tons;
    $result{tertiary_defense} = $tertiary_defense_rating;
    $result{tertiary_defense_tons} = $ter_def_tons;
    $result{marine_offense} = $marine_offense_rating;
    $result{marine_offense_tons} = $marine_tonnage[$marine_offense_rating] || 0;
    $result{marine_offense_count} = $marine_count[$marine_offense_rating] || 0;
    $result{marine_defense} = $marine_defense_rating;
    $result{marine_defense_tons} = $marine_tonnage[$marine_defense_rating] || 0;
    $result{marine_defense_count} = $marine_count[$marine_defense_rating] || 0;
    
    return %result;
}

sub commify {
    my $text = reverse $_[0];
    $text =~ s/(\d\d\d)(?=\d)(?!\d*\.)/$1,/g;
    return scalar reverse $text;
}

sub parse_qsp {
    my $qsp = shift;
    
    # QSP format: [MISSION]-[SIZE][CONFIG][MANEUVER][JUMP][HOP?]-[TL]
    # Example: BB-500U63-15 or BB-500U632-15 (with hop)
    unless ($qsp =~ /^([A-Z]{1,2})-(\d+)([UCBPSAL])(\d)(\d)(\d)?-(\d\d?)$/) {
        usage("Invalid QSP format: $qsp\nExpected format: XX-###Y##-TL or XX-###Y###-TL (e.g., BB-500U63-15)");
    }
    
    my %hull_configs = (
        U => 'Unstreamlined',
        C => 'Cluster',
        B => 'Braced',
        P => 'Planetoid',
        S => 'Streamlined',
        A => 'Airframe',
        L => 'Lifting Body',
    );
    
    my $mission = $1;
    my $tonnage = $2 * 1000;  # Convert kilotons to tons
    my $config_code = $3;
    my $maneuver = $4;
    my $jump = $5;
    my $hop = $6 || 0;
    my $tl = $7;
    
    unless (exists $hull_configs{$config_code}) {
        usage("Invalid hull configuration code: $config_code\nValid codes: U, C, B, P, S, A, L");
    }
    
    return {
        mission => $mission,
        tonnage => $tonnage,
        hull_config => $hull_configs{$config_code},
        maneuver => $maneuver,
        jump => $jump,
        hop => $hop,
        tl => $tl,
    };
}

sub usage {
    my $msg = shift;
    print "ERROR: $msg\n\n" if $msg;
    
    print <<USAGE;
Usage: $0 --qsp QSP --spine-type TYPE [options]

Required Options:
  --qsp QSP              Quick ship profile defining core characteristics
                         Format: [MISSION]-[KTONS][CONFIG][M][J][H?]-[TL]
                         Examples: BB-500U63-15 or BB-500U632-15 (with hop)
                         Battleship, 500kton, Unstreamlined, M6, J3, TL15
                         Hull configs: U=Unstreamlined, C=Cluster, B=Braced,
                                      P=Planetoid, S=Streamlined, A=Airframe, L=Lifting Body

Optional Ship Parameters:
  --spine-type TYPE      Spine weapon type: PA, Meson, Inducer, Disruptor, Stasis
                         (default: PA)
  --name NAME            Ship name or class (default: Starship)
  --spine-stage STAGE    Spine stage: Proto, Early, Standard, Improved, Modified, 
                         Advanced, Ultimate (default: Standard)
  --spine-bulk BULK      Spine bulk: VLight, Light, Medium, Heavy, VHeavy 
                         (default: Medium)
  --armor N              Primary armor rating (0-45, default: 0)
  --power N              Power plant number (default: same as maneuver from QSP)

Optional Weapon/Defense Overrides (auto-calculated if not specified):
  --offense XYZ          Three-digit offense string: secondary, tertiary, marines
                         (e.g., 987 = secondary:9, tertiary:8, marines:7)
  --defense XYZ          Three-digit defense string: secondary, tertiary, marines
                         (e.g., 864 = secondary:8, tertiary:6, marines:4)

  --help                 Show this help message

Spine Types:
  PA        - Particle Accelerator (TL 11, base 4000t, damage H)
  Meson     - Meson Gun (TL 13, base 5000t, damage L)
  Inducer   - Inducer (TL 17, base 6000t, damage G)
  Disruptor - Disruptor (TL 18, base 4000t, damage K)
  Stasis    - Stasis (TL 21, base 4500t, damage N)

Examples:
  # Basic battleship with default PA spine
  $0 --qsp BB-500U63-15 --name Dreadnought --armor 4
  
  # Destroyer with hop drive and default PA spine
  $0 --qsp DD-200S542-14 --name "Destroyer Class" --armor 3
  
  # Specify offense and defense ratings
  $0 --qsp BB-500U63-16 --name Battleship --spine-type Meson --armor 5 \\
     --offense 987 --defense 864
  
  # Advanced spine weapon
  $0 --qsp CA-100A42-16 --name "Tigress Class" --spine-type Meson \\
     --spine-stage Improved --spine-bulk Heavy --armor 5 \\
     --offense 533 --defense 444

USAGE
    exit 1;
}
