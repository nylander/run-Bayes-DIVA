#!/usr/bin/perl

## Usage: ./runDiva2.pl data.t
##
## Make sure to change the diva optimization arguments before you run
## (edit the line with $optimize_args below).
##
## Expects a Nexus-formatted tree file with taxon names containing
## areas as such: 'taxon_name:AB'.
## Taxon names and areas should not contain any non-word characters.
##
## Needs the Perl module Tie::IxHash to work (available from www.CPAN.org).
## The DIVA software needs to installed (and named "diva"). 
##
## Johan Nylander
## 08/02/2008 11:41:06 AM CEST
##

use warnings;
use strict;
use Tie::IxHash;

#################################################################
my $optimize_args     = 'maxareas=2'; # <<<<<<<<<<<<< EDIT HERE!
#################################################################

## More global variables
my $diva_out_file     = "diva.out";
my $tree_file         = "";
my $tmp_diva_in_file  = "tmp_diva_in_file";
my $tmp_diva_out_file = "tmp_diva_out_file";
my $tmp_diva_commands = "tmp_diva_commands";
my $space             = ' ';

## Open output file for all results
open my $DIVA_OUT_FILE, ">", $diva_out_file or die "Could not open the diva_out_file";

## Open big tree file
$tree_file = shift (@ARGV);
open my $TREE_FILE, "<", $tree_file or die "Could not open a tree file";

## Read the trees from the tree file, one by one
while (<$TREE_FILE>) {
    if ( /^tree/ ) {
        ## Create the tmp_diva.in file
        open my $TMP_DIVA_IN_FILE, ">", $tmp_diva_in_file or die "Could not open tmp_diva_in_file";
        print $TMP_DIVA_IN_FILE "#NEXUS\n";
        tie my %area_hash, "Tie::IxHash"; # Create a hash that can be retrieved in insertion order!
        my @tp = split;
        my $tree = "$tp[0]" . "$space" . "$tp[1]" . "$space" . "$tp[4]"; # Assumes this for the split above: tree PAUP_1 = [&R] ('Name...
        while ($tree =~ /'(\w+):(\w+)'/g) { # Get the taxon name and the distribution
            my $taxon = $1;
            my $area = $2;
            $area_hash{$taxon} = $area;
        }
        print $TMP_DIVA_IN_FILE "$tree\n";
        print $TMP_DIVA_IN_FILE "distribution ";
        foreach my $n (keys %area_hash) {
            print $TMP_DIVA_IN_FILE "$area_hash{$n} ";
        }
        print $TMP_DIVA_IN_FILE ";\noptimize $optimize_args;\n";
        print $TMP_DIVA_IN_FILE "return;\n";
        close $TMP_DIVA_IN_FILE or warn "Could not close TMP_DIVA_IN_FILE";

        ## Run diva on the $tmp_diva_in_file
        ## Create a tmp command file for diva
        open my $TMP_DIVA_COMMANDS, ">", $tmp_diva_commands or die "Can't open command file: $!\n";
        print $TMP_DIVA_COMMANDS "output $tmp_diva_out_file;\n";
        print $TMP_DIVA_COMMANDS "echo status;\n"; # print $TMP_DIVA_COMMANDS "echo none;\n"
        print $TMP_DIVA_COMMANDS "proc $tmp_diva_in_file;\n";
        print $TMP_DIVA_COMMANDS "quit;\n"; 
        close $TMP_DIVA_COMMANDS;

        ## Run diva on the command file
        system "diva < $tmp_diva_commands";

        ## Remove the command file
        unlink "$tmp_diva_commands" or warn "Could not remove the tmp_diva_commands file";
       
        ## Remove the $tmp_diva_in_file
        unlink "$tmp_diva_in_file" or warn "Could not remove the tmp_diva_in_file file";
        
        ## Read the output from diva, filter, and append it to the big output file
        open my $TMP_DIVA_OUT_FILE, "<", $tmp_diva_out_file or die "Could not open tmp_diva_out_file";
        while (<$TMP_DIVA_OUT_FILE>) {
            if (/^paup/) {
                print $DIVA_OUT_FILE "$_";
            }
            elsif (/^node/) {
                print $DIVA_OUT_FILE "$_";
            }
        }

        ## Remove tmp_diva_out_file
        close $TMP_DIVA_OUT_FILE or warn "Could not close TMP_DIVA_OUT_FILE";
        unlink "$tmp_diva_out_file" or warn "Could not remove the tmp_diva_out_file file";
    }
}

close $DIVA_OUT_FILE or warn "Could not close DIVA_OUT_FILE";

exit(0);


