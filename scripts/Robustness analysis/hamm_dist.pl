#!/usr/bin/perl -w
use strict;
use warnings;

my $file1 = 'mutant.temp';
my $file2 = 'wt.temp';

open my $info1, $file1 or die "Could not open $file1: $!";
open(my $fh, '>', 'report.temp');
while( my $line1 = <$info1>){
	open(my $fh2, '>', 'report_mutant.temp');
	open my $info2, $file2 or die "Could not open $file2: $!";
	my $comp = "1000";
	my $mut_name = (split '\t', $line1)[0];
	my $mut_state = (split '\t', $line1)[1];
	$mut_state =~ s/_//g;
	while( my $line2 = <$info2>){
		my $wt_name = (split '\t', $line2)[0];
		my $wt_state = (split '\t', $line2)[1];
		$wt_name =~ s/_//g;
		$wt_state =~ s/_//g;
		my $result = hd($wt_state,$mut_state);
		if ($result < $comp){
			$comp = $result;
			print "$mut_name\t$wt_name\t$result\n";
			print $fh2 "$mut_name\t$wt_name\t$result\n";
		}
	}
	close $info2;
	my $fh3 = `tail -n 1 report_mutant.temp`;
	print $fh "$fh3";
	close $fh2;
	unlink "report_mutant.temp";
}

close $fh;
close $info1;

sub hd
{
     # String length is assumed to be equal
     my ($k,$l) = @_;
     my $len = length ($k);
     my $num_mismatch = 0;

     for (my $i=0; $i<$len; $i++)
     {
      ++$num_mismatch if substr($k, $i, 1) ne substr($l, $i, 1);
     }

     return $num_mismatch;
}
