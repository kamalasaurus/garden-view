#!/usr/bin/perl
use strict;
use warnings;
use Text::CSV;
use JSON;

# Input and output file names
my ($csv_file, $json_file) = @ARGV;

# Open the CSV file
open my $fh, '<', $csv_file or die "Could not open '$csv_file' $!\n";

# Create CSV parser
my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });

# Read the header
my $header = $csv->getline($fh);

# Array to hold all rows as hashrefs
my @rows;

# Read each row and convert to hashref
while (my $row = $csv->getline($fh)) {
    my %data;
    @data{@$header} = @$row;
    push @rows, \%data;
}

close $fh;

# Convert array of hashrefs to JSON
my $json = JSON->new->utf8->pretty->encode(\@rows);

# Write to output file
open my $out, '>', $json_file or die "Could not open '$json_file' $!\n";
print $out $json;
close $out;

print "Conversion complete. JSON saved to $json_file\n";
