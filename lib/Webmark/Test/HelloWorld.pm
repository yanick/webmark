package Webmark::Test::HelloWorld;

use 5.20.0;

use strict;
use warnings;

use Moose;

use experimental 'signatures';

with 'Webmark::Test';

sub speedtest ($self,$test=0) {
    state $mech = $self->mech;
    $mech->get('/');

    $self->mech->content_is('hello world') if $test;
}

1;
