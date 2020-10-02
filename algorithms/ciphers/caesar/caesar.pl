#!/usr/bin/perl
#
# caesar.pl - implement a simple caesar cipher in Perl
#
# Usage: perl caesar.pl (action) (chars_to_shift) 'text'
#
# action: string representing action to be taken, either "encrypt" or "decrypt"
# chars_to_shift: integer between 0 and 26
# text: string to be encrypted/decrypted
#####

use strict;
use warnings;

sub encrypt {
  my($charsToShift,$plaintext) = @_;
  my $alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  my $shiftedAlphabet = shiftAlphabet($alphabet,$charsToShift);
  my $ciphertext = "";

  my $count = 0;
  while ($count < length($plaintext)) {
    my $workChar =  substr($plaintext,$count,1);
    my $workCharIndex = index($alphabet,$workChar);
    if ($workCharIndex ne "-1") {
      $ciphertext = $ciphertext . substr($shiftedAlphabet,$workCharIndex,1);
    } else {
      $ciphertext = $ciphertext . $workChar;
    }
    $count++;
  }
  return $ciphertext;
}

sub decrypt {
  my($charsToShift,$ciphertext) = @_;
  my $alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  my $shiftedAlphabet = shiftAlphabet($alphabet,$charsToShift);
  my $count = 0;
  my $plaintext = "";

  while ($count < length($ciphertext)) {
    my $workChar =  substr($ciphertext,$count,1);
    my $workCharIndex = index($shiftedAlphabet,$workChar);
    if ($workCharIndex ne "-1") {
      $plaintext = $plaintext . substr($alphabet,$workCharIndex,1);
    } else {
      $plaintext = $plaintext . $workChar;
    }
    $count++;
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
  my $charsToShift = $ARGV[1];
  my $uppertext = uc($ARGV[2]);

  if ($charsToShift =~ /^\d+\z/) {
    if ($charsToShift <= 26) {
      if ($action eq "ENCRYPT") {
        $error = "FALSE";
        print encrypt($charsToShift,$uppertext);
      } elsif ($action eq "DECRYPT") {
        $error = "FALSE";
        print decrypt($charsToShift,$uppertext);
      }
    }
  }
}

if ($error eq "TRUE") {
  print "Usage: perl caesar.pl (action) (chars_to_shift) 'text'\r\n\r\n";
  print "action: string representing action to be taken, either \"encrypt\" or \"decrypt\"\r\n";
  print "chars_to_shift: integer between 0 and 26\r\n";
  print "text: string to be encrypted/decrypted, enclose in single quotes\r\n\r\n";
  exit 0;
}


exit 0;
