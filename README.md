# acs-starships
Catalog of Adventure-Class Starships for the Traveller RPG.

At a minimum, entries should be a design file in the T5DesktopShipyard data format, either in YAML, JSON, or XML.  If a suitable alternate format and shipyard program emerges (e.g. fully supporting a final .acs format), then that can be used instead. 

Preferably, these entries are also accompanied by a text file and HTML file of the design.

## Repository layout

- `ships/`: starship source and generated files, organized by polity/faction.
- `t5ds/`: helper scripts and Perl modules used to process, compile, and convert ship data.

## Notes for contributors

- Ship content now lives in `ships/` at the repository root.
- When running helper scripts from `t5ds/`, use path patterns that point at `../ships/`.
