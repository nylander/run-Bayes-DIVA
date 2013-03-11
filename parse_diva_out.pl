#!/usr/bin/perl 
#===============================================================================
#
#         FILE:  parse_diva_out.pl
#
#        USAGE:  ./parse_diva_out.pl diva.out
#                ./parse_diva_out.pl diva.out > output
#
#  DESCRIPTION:  A quick and dirty (see DISCLAIMER!) way of parsing the output
#                from multiple DIVA runs.
#                The script reads the text in the diva.out file given as 
#                    (anc. of terminals X-Y): AREA(S)
#                and prints a list of uniqe X-Y combinations along with the
#                AREA(S) and the number of unique areas for the X-Y pair.
#                The script prints to stdout as well as to a tab-
#                delimited file ("parsed.diva.out") with the format:
#                X-Y_pair rec1 n_rec1 rec2 n_rec2 ...
#
#   DISCLAIMER:  The output from this script has not been verified/tested for
#                accuracy. A potential pitfall is the parsing on unique X-Y
#                pairs from the DIVA output where, potentially(?), a node in
#                the target tree (the tree to be used as display tree for any
#                possible summary of the analysis) may have several X-Y pairs.
#                The DIVA program also changes and truncates the taxon labels
#                in the output. These pitfalls might have to be dealt with.
#                Caveat emptor. 
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  No error checking. Read the DISCLAIMER.
#       AUTHOR:  Johan A. A. Nylander (JN), <jnylander @ users.sourceforge.net>
#      COMPANY:  SU
#      VERSION:  1.0
#      CREATED:  12/08/2009 11:23:23 AM CET
#     REVISION:  12/08/2009 12:03:34 PM CET
#===============================================================================

use strict;
use warnings;

my %HoH     = (); # Key: taxon pair, Value: hash with Key:area reconstruction, Value: number of times found
my $outfile = 'parsed.diva.out';
my $infile  = shift;
my $ntrees  = 0;

open my $INFILE, "<", $infile or die "could not open diva.out file : $! \n";
while (<$INFILE>) {
    chomp;
    if (/tree read successfully/) {
        $ntrees++;
        next;
    }
    my (@parts) = split /anc. of terminals/, $_;
    my ($pair, $areas) = split /\):\s/, $parts[1];
    $pair =~ s/\s//g;
    $HoH{$pair}{$areas}++;
}
close($INFILE);

print STDERR "Read $ntrees trees.\n";

open my $OUTFILE, ">", $outfile or die "could not open outfile : $! \n";

for my $pair ( keys %HoH ) {
    print STDOUT "$pair:\n";
    print $OUTFILE "$pair\t";
    for my $areas ( keys %{ $HoH{$pair} } ) {
         print STDOUT "\t$areas = $HoH{$pair}{$areas}\n";
         print $OUTFILE "$areas\t$HoH{$pair}{$areas}\t";
    }
    print STDOUT "\n";
    print $OUTFILE "\n";
}
close($OUTFILE) or warn "could not close outfile : $! \n";

print STDERR "Printed $outfile.\n";
print STDERR "This ouptput could potentially be used to try to map the reconstructions on a \'target\' tree.\n";
print STDERR "Please read the DISCLAIMER in the original $0 file.\n";

exit(0);

