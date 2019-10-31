#!/usr/bin/perl
#
# vigenere.pl - implement a vignere cipher in Perl
#
# Usage: perl vignere.pl (action) 'keyphrase' 'text'
#
# action: string representing action to be taken, either "encrypt" or "decrypt"
# keyphrase: string to be used as keyphrase, enclosed in single quotes 
# text: string to be encrypted/decrypted, enclosed in single quotes
#
# (NOTE: Non alpha characters will be stripped from keyphrase!)
#####

use strict;
use warnings;

sub encrypt {
  my($keyphrase,$plaintext) = @_;
  my $ciphertext = "";

  my $count = 0;
  while ($count < length($plaintext)) {
    my $count2 = 0;
    LOOP: while ($count2 < length($keyphrase)) {
      my $alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      my $workChar =  substr($plaintext,$count,1);
      my $workCharIndex = index($alphabet,$workChar);
      my $shiftedAlphabet = shiftAlphabet($alphabet,index($alphabet,substr($keyphrase,$count2,1),1));
      if ($workCharIndex ne "-1") {
        $ciphertext = $ciphertext . substr($shiftedAlphabet,$workCharIndex,1);
      } else {
        $ciphertext = $ciphertext . $workChar;
        $count2--;
      }
      $count++;
      unless ($count < length($plaintext)) {
        last LOOP;
      }
      $count2++;
    }
  }
  return $ciphertext;
}

sub decrypt {
  my($keyphrase,$ciphertext) = @_;
  my $plaintext = "";

  my $count = 0;
  while ($count < length($ciphertext)) {
    my $count2 = 0;
    LOOP: while ($count2 < length($keyphrase)) {
      my $alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
      my $workChar =  substr($ciphertext,$count,1);
      my $shiftedAlphabet = shiftAlphabet($alphabet,index($alphabet,substr($keyphrase,$count2,1),1));
      my $workCharIndex = index($shiftedAlphabet,$workChar);
      if ($workCharIndex ne "-1") {
        $plaintext = $plaintext . substr($alphabet,$workCharIndex,1);
      } else {
        $plaintext = $plaintext . $workChar;
        $count2--;
      }
      $count++;
      unless ($count < length($ciphertext)) {
        last LOOP;
      }
      $count2++;
    }
  }
  return $plaintext;
}

sub shiftAlphabet {
  my($alphabet,$charsToShift) = @_;
  my $shiftedAlphabet = substr($alphabet,$charsToShift) . substr($alphabet,0,$charsToShift);
  return $shiftedAlphabet;
}

my $error = "TRUE";
my $num_args = 	$#ARGV + 1;

if ($num_args == 3) {
  my $action = uc($ARGV[0]);
  my $keyphrase = uc($ARGV[1]);
  my $uppertext = uc($ARGV[2]);
  $keyphrase =~ s/[^a-zA-Z]//g;

  if ($action eq "ENCRYPT") {
    $error = "FALSE";
    print encrypt($keyphrase,$uppertext);
  } elsif ($action eq "DECRYPT") {
    $error = "FALSE";
    print decrypt($keyphrase,$uppertext);
  }
}

if ($error eq "TRUE") {
  print "Usage: perl caesar.pl (action) 'keyphrase' 'text'\r\n\r\n";
  print "action: string representing action to be taken, either \"encrypt\" or \"decrypt\"\r\n";
  print "keyphrase: string to be used as keyphrase, enclosed in single quotes\r\n"; 
  print "text: string to be encrypted/decrypted, enclosed in single quotes\r\n\r\n";
  print "(NOTE: Non alpha characters will be stripped from keyphrase!)\r\n\r\n";
  exit 0;
}

exit 0;
