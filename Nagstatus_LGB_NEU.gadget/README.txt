Nagstatus Gadget V1.5.0
2008-06-29 / Jouko Markkanen <jouko@markkanen.net>

This gadget displays statistics summary of systems monitored by a Nagios
server. Clicking on the gadget brings up a flyout that displays a list of all
hosts and services monitored by the Nagios installation, along with a coloured
dot that shows the status. Also for non-OK hosts/services, the check plugin
output is displayed.

As Nagios itself does not lend it's data in a programmatic way, the gadget
contains a Perl script that must be placed on a web server that has local
file access to Nagios' status.dat file (usually on the Nagios server itself).
The script converts the status.dat file to XML format and returns requested
elements of the data structure.The script is located as
XMLProviderScript\nagxmlstatus.cgi under the installed gadget folder. There
is a configurable variable in nagxmlstatus.cgi $STATUSFILE, that must point
to Nagios' status.dat file. Also make sure that the script is executable
(run "chmod a+x nagxmlstatus.cgi").
The script requires Perl module XML::LibXML, which is available as
perl-XML-LibXML (rpm-based) and libxml-perl (Debian based) package on most
Linux distributions. If you cannot locate the distribution's package, run:
% perl -MCPAN -e "install XML::LibXML"
on command shell.

About configuration:
* Window title is an optional string that is displayed on top of gadget
  window. The purpose of this is to identify which Nagios' status is displayed
  in case you use multiple gadgets to monitor multiple Nagios installations.
* Nagios Web UI URL is the URL to Nagios you want to monitor. This URL must
  have a cgi-bin subdirectory where Nagios' cgi executables are located.
* XML Status Provider URL is the URL to access nagxmlstatus.cgi or static XML
  file produced by it (see Note for bigger environments below). If you place
  nagxmlstatus.cgi to Nagios' cgi-bin directory (mentioned above), you can leave
  this blank.
* URL points to: leave as Script if the previous URL points to the
  nagxmlstatus.cgi script itself, choose File if it points to a static XML
  file (this selects whether we append CGI parameters to the request).
* Username and Password are used for HTTP authentication to access XML Status
  Provider.
* Refresh every xx seconds sets the refresh interval at which the XML status
  is reloaded and gadget display refreshed.
* Last you can specify a pathname to sound file that will be played whenever
  a host's or service's state changes. You can click browse to locate the file.

Note for bigger environments:
The nagxmlstatus.cgi script is quite cpu-heavy. If you have a large Nagios
installation (100+ hosts and/or several gadgets polling the same server) this
can burden the server too much. To lighten the load on server, you can make
nagxmlstatus.cgi run via a scheduler (eg. cron) periodically and redirect the
output to a static file. Put the file to somewhere under your httpd's document
root directory and point the gadget's XML Provider URL setting to this file.
The proper command line for nagxmlstatus.cgi is:
nagxmlstatus.cgi -n host,service,program -e current_state,plugin_output,problem_has_been_acknowledged,last_state_change,program_start,last_command_check,scheduled_downtime_depth

If you have questions/suggestions/whatnot, feel free to e-mail me at
jouko@markkanen.net.
