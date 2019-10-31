#!/usr/bin/perl
#
# atbash.pl - implement a simple atbash cipher in Perl
#
# Usage: perl atbash.pl 'text'
#
# text: string to be encrypted/decrypted
#####

use strict;
use warnings;

sub doCrypt {
  my($inputText) = @_;
  my $inputAlphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  my $outputAlphabet = "ZYXWVUTSRQPONMLKJIHGFEDCBA";
  my $outputText = "";

  my $count = 0;
  while ($count < length($inputText)) {
    my $workChar =  substr($inputText,$count,1);
    my $workCharIndex = index($inputAlphabet,$workChar);
    if ($workCharIndex ne "-1") {
      $outputText = $outputText . substr($outputAlphabet,$workCharIndex,1);
    } else {
      $outputText = $outputText . $workChar;
    }
    $count++;
  }
  return $outputText;
}

my $error = "TRUE";
my $num_args = 	$#ARGV + 1;

if ($num_args == 1) {
  my $uppertext = uc($ARGV[0]);
  $error = "FALSE";
  print doCrypt($uppertext);
}

if ($error eq "TRUE") {
  print "Usage: perl atbash.pl 'text'\r\n\r\n";
  print "text: string to be encrypted/decrypted, enclose in single quotes\r\n\r\n";
  exit 0;
}


exit 0;
