# Starships

Catalog and tooling for Starships for Traveller.

The repository stores ship designs plus utility scripts that generate derived outputs
such as ACS text, HTML, infobox snippets, and tabular summaries.

## Browse The Catalog

If you want to explore ships (rather than generate files), start in `acs-ships/`.

- Catalog index: [SHIP-INDEX.md](SHIP-INDEX.md)

Catalog groups currently under `acs-ships/`:

- `aslan`
- `carillian`
- `darrian`
- `daystar-mityo`
- `delta-research`
- `droyne`
- `galaxiad`
- `imperial`
- `judges-guild`
- `kursae`
- `sword-worlds`
- `unclassified`
- `vargr`
- `virushi`
- `zhodani`

Current catalog snapshot:

- `186` YAML source designs (`.yml`)
- `186` rendered sheets (`.html`)
- `175` ACS text exports (`.acs.txt`)

Quick browsing commands:

```bash
# List all available groups
find acs-ships -mindepth 1 -maxdepth 1 -type d | sort

# List designs in one group
find acs-ships/imperial -maxdepth 1 -type f -name "*.yml" | sort

# Find by partial ship name or code from filenames
find acs-ships -type f -name "*.yml" | grep -i "far trader"

# See available rendered sheets
find acs-ships -type f -name "*.html" | sort
```

Design files usually appear as a set with the same base name:

- `.yml` source
- `.acs` export
- `.acs.txt` text summary
- `.html` rendered sheet
- optional `.infobox.txt`

## Repository Layout

- `acs-ships/`
	- Canonical ship content organized by faction/polity.
	- Common files per design include source `.yml` plus generated `.acs`, `.acs.txt`, `.html`, and optional `.infobox.txt`.
- `acs-utils/`
	- Perl utilities for format conversion, summarization, and batch processing.
	- Includes shared modules such as `ACS.pm`, `AcsYAML2Acs.pm`, and `AcsYAML2Html.pm`.
- `bcs-utils/`
	- Battle/Capital ship design scripts and notes.
	- Main entrypoint: `shipbuilder.pl`.
- `acs-in-basic/`
	- Legacy BASIC and related data/listing files used by earlier builder workflows.
- `acs-shipyard-cli/`
	- Separate Python-based CLI shipyard experiment.
- `Starports/`
	- Reference material.

## Data and Outputs

Canonical design source in this repo is the YAML design file (`.yml`) in `acs-ships/`.

Typical generated artifacts:

- `.acs`: ACS export output.
- `.acs.txt`: YAML-like ACS text summary.
- `.html`: rendered design sheet.
- `.infobox.txt`: wiki-style infobox text generated from `.acs.txt`.

## Prerequisites

- Perl 5.
- Perl modules used by scripts in `acs-utils/` and `bcs-utils/` (notably `YAML`, plus standard modules such as `strict`, `autodie`, and `Data::Dumper`).

## Common Workflows

Run commands from repository root unless noted.

### Convert One YAML Design

Generate ACS and HTML from a YAML source file:

```bash
perl acs-utils/acs-2-acs.pl "acs-ships/imperial/Im-- A2-S442 Far Trader.yml"
perl acs-utils/acs-2-html.pl "acs-ships/imperial/Im-- A2-S442 Far Trader.yml"
```

### Batch Convert in a Directory

The batch helper expects to run inside a directory containing `.yml` files:

```bash
cd acs-ships/imperial
perl ../../acs-utils/acs-build-all.pl
```

### Generate Infobox Text

Create an infobox snippet from an `.acs.txt` file:

```bash
perl acs-utils/acs-2-infobox.pl "acs-ships/imperial/Im-- A2-S442 Far Trader.acs.txt"
```

### Start a New YAML Skeleton

Create a starter YAML design from class/QSP/TL:

```bash
perl acs-utils/acs-start.pl "Far Trader" "A2-S442" 12 > "acs-ships/unclassified/Far Trader.yml"
```

### Summarize Designs to CSV

`acs-summarize-to-csv.pl` emits rows for `.yml` inputs in the current directory:

```bash
cd acs-ships/imperial
perl ../../acs-utils/acs-summarize-to-csv.pl > imperial-ships.csv
```

## BCS Tooling

`bcs-utils/shipbuilder.pl` generates battle/capital ship data and supports rich CLI options.

Example:

```bash
perl bcs-utils/shipbuilder.pl --qsp BK-500U63-15 --name Tigress --spine-type Meson --spine-stage Advanced --spine-bulk Heavy --armor 19 --offense 995 --defense 995
```

For full option help:

```bash
perl bcs-utils/shipbuilder.pl --help
```

## Contribution Notes

- Keep source `.yml` and generated derivatives together under the appropriate `acs-ships/<group>/` folder.
- When adding or modifying designs, regenerate corresponding derived files (`.acs`, `.acs.txt`, `.html`, and where needed `.infobox.txt`).
- Prefer script-driven generation over hand-editing generated output files.
