#!/usr/bin/perl -w
#Written by Mac Campbell DrMacCampbell@gmail.com
#Revised 4/12/2016
#Outputs the number of restriction sites, average fragment sizes, total number of fragments, and how many contigs were provided
#Usage restrictionAnalysis.pl SbfI genome.fasta

#Update 11/25/2020. Can't access bioperl. Using a workaround
#perl -I ~/perl5/lib/perl5/ ~/Dropbox/bin/restrictionAnalysis.pl SbfI omy01.fasta

my $re=shift;
my $fasta=shift;

use Bio::Restriction::Analysis;
use Bio::Restriction::EnzymeCollection;
use Bio::SeqIO;
use List::Util;


my @fragLengths;
my @brokenSeqs;
my $seqCntr=0;
my $cuts=0;
my $all_collection = Bio::Restriction::EnzymeCollection->new();
my $enzyme = $all_collection->get_enzyme("$re");

my $seqio = Bio::SeqIO->new(-file => "$fasta", '-format' => 'Fasta');
while(my $seq = $seqio->next_seq) {
  my $string = $seq->seq;
  $seqCntr++;
  #print $string;
  my $ra = Bio::Restriction::Analysis->new(-seq=>$seq);
 @fragments = $ra->fragments($enzyme);
 $cuts+=$ra->cuts_by_enzyme("$re");
#print join ("\n",@fragments);
#print ("\n");

foreach my $seq (@fragments) {
	push (@brokenSeqs, $seq);
	push (@fragLengths, length( $seq ));	

	}
}


#print join ("\n",@brokenSeqs);
my $totalFragments = @brokenSeqs;
#print join ("\t",@fragLengths);
#print "my totalFragments:\t$totalFragments\n";
print ("\n");

my $total=0;
foreach my $number ( @fragLengths ) {
	$total=$total+$number;

}
my $arrSize = @fragLengths;

my $average=$total/$arrSize;

print "The total number of restriction sites for $re is:\t$cuts\n";
print "The average fragment size is:\t$average\n";
print "The total number of fragments is:\t$totalFragments\n";
print "The total number of genome contigs:\t$seqCntr\n";
