#!/bin/perl
use strict;
use warnings;
use Term::UI;
use Term::ReadLine;

my $term = Term::ReadLine->new('BizarreAdventure');
my $bool = $term->ask_yn(
    print_me => 'WRYYYYYYYYYYYYYYY!!',
    prompt   => 'Will you give up to live as a human?',
    default  => 'y',
)

my $choice_reply = $term->get_reply(
    prompt  => 'right fist or left fist?',
    choices => [qw|right left both|],
    default => 'both',
);
‚±‚ê

