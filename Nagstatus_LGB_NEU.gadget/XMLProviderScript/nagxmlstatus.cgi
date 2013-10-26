#!/usr/bin/perl -w
use strict;

##################################################
# nagxmlstatus.cgi                               #
# Presents Nagios status.dat in XML format       #
# (C) 2008 Jouko Markkanen <jouko@markkanen.net> #
# V 1.5.0 / 2008-06-29                           #
##################################################

###
# Configuration parameters
#

my $STATUSFILE = "/var/log/nagios/status.dat";

###
# Modules
#

use XML::LibXML;
use CGI;


###
# Initialize variables
#
my $DOMXML = XML::LibXML::Document->new('1.0',"ISO-8859-1");
my $ROOT = $DOMXML->createElement('nagstatus');
my $SUM = $DOMXML->createElement('summary');
my $SRV = $DOMXML->createElement('services');
my $LASTCHANGE = 0;
my $REQ = new CGI;
my $NODE = undef;
my $NODENAME = undef;
my @NODES;
my @ELEMENTS;
$DOMXML->addChild($ROOT);


###
# Check run mode
#
if (!defined($REQ->request_method)) {
        # Load GetOpts
        require 'Getopt/Std.pm';
        import Getopt::Std;
        # Running in commandline mode
        if ($#ARGV == -1) {
                # Report error, we have no HTTP request method nor any cmdline params
                print "We are either running from commandline with inproper parameters, or the HTTP CGI request environment is incorrect.\n";
                print "Usage: \n";
                print "    nagxmlstatus.cgi [-f status.dat] <-n nodes> <-e elements>\n";
		print "        -f status.dat     specifies path to Nagios status.dat file\n";
                print "        -n <node,...>     specifies a node(s) (object) to return\n";
                print "                          multiple nodes can be specified as a comma-separated list\n";
                print "        -e <element,...>  specifies element(s) (object's value) to return\n";
                print "                          multiple elements can be specified as a comma-separated list\n";
                print "\n";
                print "                       A special value \"all\" is valid for both -n and -e.\n";
                print "                       This returns all nodes/elements available\n\n";
                exit 255;
        }
        my %OPTS;
        getopt('nef', \%OPTS);
	if (!(defined($OPTS{'n'}) && defined($OPTS{'e'}))) {
		print "At least one node (-n parameter) and one element (-e parameter) must be specified!\n";
		print "Run without commandline parameters for usage.\n\n";
		exit 255;
	}
        @NODES = split(/,/,$OPTS{'n'});
        @ELEMENTS = split(/,/,$OPTS{'e'});
	if (defined($OPTS{'f'})) {
            if ($OPTS{'f'} ne '') {
		$STATUSFILE = $OPTS{'f'};
            }
	}
} else {
        # Running under CGI
        # Get parameters from HTTP request
        @NODES = $REQ->param('node');
        @ELEMENTS = $REQ->param('elem');
}

###
# Check user authentication
#

# <not implemented yet>

###
# Parse response filtering
#

# Open statusfile
open(INPUT, "$STATUSFILE") || die "Error opening nagios statusfile $STATUSFILE!\n";

# Parse statusfile to XML format
while (<INPUT>) {
    if ($_ =~ /^(\w*) \{/) {
        # If previous object was a service, attach it to correct host
        if ($NODE && ($NODE->nodeName eq 'service') && (grep(/^service$/, @NODES) || ($NODES[0] eq 'all'))) {
            foreach my $HOST ($ROOT->getElementsByTagName('host')) {
                if ($NODE->getAttribute('host') eq $HOST->getAttribute('name')) {
                    $HOST->appendChild($NODE);
                    last;
                }
            }
        }
        # Set node name, a nasty kludge to ensure compatibility with new
        # status.dat format with Nagios 3.x
        $NODENAME = $1;
        $NODENAME = 'host' if ($NODENAME eq 'hoststatus');
        $NODENAME = 'service' if ($NODENAME eq 'servicestatus');
        $NODENAME = 'program' if ($NODENAME eq 'programstatus');
        # Create new node
        $NODE = $DOMXML->createElement($NODENAME);
        # If the node is not service, attach it to rootnode
        $ROOT->appendChild($NODE) if (($NODENAME ne 'service') && (grep(/^($NODENAME)$/, @NODES) || ($NODES[0] eq 'all')));
    } elsif ($_ =~ /^\s*(\w*)=(.*)$/) {
        my ($N, $V) = ($1, $2);
        $NODE->setAttribute('name', $V) if (($NODE->nodeName eq 'host') && ($N eq 'host_name'));
        $NODE->setAttribute('description', $V) if (($NODE->nodeName eq 'service') && ($N eq 'service_description'));
        $NODE->setAttribute('host', $V) if (($NODE->nodeName eq 'service') && ($N eq 'host_name'));
        if ((grep(/^($N)$/, @ELEMENTS)) || ($ELEMENTS[0] eq 'all')) {
            my $CHILD = $DOMXML->createElement($N);
            my $VALUE = $DOMXML->createTextNode($V);
            $CHILD->appendChild($VALUE);
            $NODE->appendChild($CHILD);
        }
        if ($N eq 'last_state_change') {
            if ($V > $LASTCHANGE) {
                $LASTCHANGE = $V;
            }
        }
    }
}

# If last object was service, attach it to a host
if ($NODE && ($NODE->nodeName eq 'service') && grep(/^service$/, @NODES)) {
    foreach my $HOST ($ROOT->getElementsByTagName('host')) {
        if ($NODE->getAttribute('host') eq $HOST->getAttribute('name')) {
            $HOST->appendChild($NODE);
            last;
        }
    }
}

# Add 'last_state_change' element to 'program' node if that has been requested
if ((grep(/^program$/, @NODES) || ($NODES[0] eq 'all')) && ((grep(/^last_state_change$/, @ELEMENTS)) || ($ELEMENTS[0] eq 'all'))) {
    $NODE = $DOMXML->createElement('last_state_change');
    my $VALUE = $DOMXML->createTextNode($LASTCHANGE);
    $NODE->appendChild($VALUE);
    foreach my $PROG ($ROOT->getElementsByTagName('program')) {
        $PROG->appendChild($NODE);
    }
}

# Close statusfile
close INPUT;

# Print output
if (defined($REQ->request_method)) {
        print $REQ->header(-type=>'text/xml',
                   -expires=>'-1');
}
$DOMXML->normalize;
print $DOMXML->toString;

# Finished
exit 0;