

for (<*.yml>)
{
	`perl acs-2-acs.pl '$_'`;
	`perl acs-2-html.pl '$_'`;
}