run-Bayes-DIVA
==============

Some scripts used for the "Bayes-DIVA" analysis of Thrushes in Nylander et al. 2008.


Description
-----------

These Perl scripts runs the program [DIVA](http://sourceforge.net/projects/diva) on a number of rooted phylogenetic trees in a specific nexus format, and then summarizes the frequencies of ancestral area reconstructions on nodes.


Reference
---------

Nylander, J.A.A., U. Olsson, P. Alstr&ouml;m, and I. Sanmartin. 2008. Accounting for phylogenetic uncertainty in biogeography: A Bayesian approach to dispersal- vicariance analysis of the thrushes (Aves: Turdus). [Systematic Biology 57:257-268](http://sysbio.oxfordjournals.org/content/57/2/257.abstract).


Usage
-----

1. Make sure the DIVA program is installed.

2. Make sure that the taxon labels in the input tree files are labeled following this scheme (see example file data.trees). Where the name and the area symbols (in this example A and B) are separated by a semicolon:

    Taxon\_1:AB

    Taxon\_2:A

    Taxon\_3:B

3. Make sure to edit the runDiva2.pl file to add the desired arguments to the diva program, and the path to the diva executable file.

4. Run diva using the runDiva2.pl script:

    ./runDiva2.pl data.trees

5. Parse the output using the parse\_diva_out.pl script:

    ./parse\_diva\_out.pl diva.out > output


Dependencies
------------

Needs the program [DIVA](http://sourceforge.net/projects/diva) installed as 'diva' in the path.
Needs the Perl module Tie::IxHash to work (available from [CPAN](http://www.CPAN.org).


Files
-----

    data.trees -- Example of (rooted) trees used as input.

    diva.out -- Example of output from a diva analysis.

    parse_diva_out.pl -- Script to parse the diva output.

    parsed.diva.out -- Example output from the parse_diva_out.pl script.
                       The file is tab separated and information is given on two taxon labels
                       that can point to a node in the tree, then the reconstruction, followed
                       by the frequency for the reconstruction. With many alternative
                       reconstructions, the frequencies should sum up to 100.

    runDiva2.pl -- Script for running diva.



Disclaimer and Background Info
------------------------------

Tested on Ubuntu Linux.

June 4 2009

"Thank you for your interest in the paper in Systematic Biology (Nylander et al., 2008. Syst. Biol. 57:257-268). Unfortunately, the scripts that were used in the paper are not available as as standalone ready-to-use package. I was hoping to be able to complete such a package but lack of time and funding put a stop to that. However, I'm attaching a Perl script for submitting several trees to DIVA (runDiva2.pl). You need to parse the output from DIVA using your own methods. I run all my analysis on Linux (and occasionally MacOSX), and the script might need some customization on a windows machine. If you need the code for the DIVA program, try to contact the author (Fredrik Ronquist, Swedish Museum of Natural History, Stockholm).

Good luck,

Johan"

UPDATE Dec 8 2009:

You might try out this Perl script parse_\diva_out.pl to get you going on the DIVA output. But please read the Disclaimer in the script file!



