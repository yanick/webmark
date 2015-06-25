package Webmark::Test;

use 5.20.0;

use strict;
use warnings;

use Moose::Role;

use Test::WWW::Mechanize;
use Test::More;
use Timer::Simple;
use Webmark::Stats;
use JSON qw/ from_json to_json /;

has "mech" => (
    isa => 'Test::WWW::Mechanize',
    is => 'ro',
    lazy => 1,
    default => sub {
        my $self = shift;
        Test::WWW::Mechanize->new; 
    },
);

has base_url => (
    isa => 'Str',
    is => 'ro',
    lazy => 1,
    default => sub {
        return $ENV{WEBMARK_BASE} || 'http://localhost:3000';
    },
);

has "running_time" => (
    isa => 'Int',
    is => 'ro',
    default => 10,
);

has "stats" => (
    isa => 'Webmark::Stats',
    is => 'ro',
    lazy => 1,
    default => sub {
        Webmark::Stats->new;
    },
);

has "data" => (
    is => 'ro',
    default => sub { {} },
);

requires 'speedtest';

before 'run_speedtest' => sub {
    my $self = shift;

    $self->mech->get( $self->base_url . '/specs' );

    return unless $self->mech->status == 200;

    eval { $self->data->{specs} = from_json( $self->mech->content ) };
};

after run_speedtest => sub {
    my $self = shift;
    
    say to_json( $self->data, { pretty => 1, canonical => 1 } );
};

sub run_speedtest {
    my $self = shift;

    my $start =  time;

    my $builder = Test::More->builder;
    my $output;
    my $error;
    $builder->output(\$output);
    $builder->failure_output(\$error);

    $self->speedtest(1);

    die "something didn't work out\n$output\n$error"
        unless $builder->is_passing;

    while( time - $start < $self->running_time ) {
        my $timer = Timer::Simple->new;
        $self->speedtest;
        $self->stats->record($timer->elapsed);
    }

    die "something didn't work out after the speedtest\n$output\n$error"
        unless $builder->is_passing;

    done_testing();

    $self->data->{running_time} = $self->stats->as_hashref;
}



1;



