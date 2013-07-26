#!/usr/bin/env perl

use strict;
use warnings;
use TestUtils;
use SeqIO;
use Test::More tests => 18;

my $test_proper = TestUtils->new( build_proper => 1, destroy => 0 );
my $seq_num = 1;

my $proper_fa_arr = $test_proper->fasta_constructor;
my $proper_fq_arr = $test_proper->fastq_constructor;

# test parsing correctly formatted sequence files
for my $fa (@$proper_fa_arr) {
    my $seqio_fa = SeqIO->new( file => $fa );
    my $seqfh = $seqio_fa->get_fh;
    while (my $seq = $seqio_fa->next_seq($seqfh)) {
	ok( $seq->has_id,     "Fasta sequence $seq_num has an ID" );
	ok( $seq->has_seq,    "Fasta sequence $seq_num has a sequence" );
	ok( ! $seq->has_qual, "Fasta sequence $seq_num does not have quality scores" );
    }
    unlink $fa;
    $seq_num++;
}

for my $fq (@$proper_fq_arr) {
    my $seqio_fq = SeqIO->new( file => $fq );
    my $seqfh = $seqio_fq->get_fh;
    while (my $seq = $seqio_fq->next_seq($seqfh)) {
	ok( $seq->has_id,   "Fastq sequence $seq_num has an ID" );
	ok( $seq->has_seq,  "Fastq sequence $seq_num has a sequence" );
	ok( $seq->has_qual, "Fastq sequence $seq_num has quality scores" );
    }
    unlink $fq;
    $seq_num++;
}

done_testing();