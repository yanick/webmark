package Webmark::Test::CountUp;

use 5.20.0;

use strict;
use warnings;

use Moose;

use experimental 'signatures';

use JSON qw/ from_json /;
use Test::More;

with 'Webmark::Test';

sub speedtest ($self,$test=0) {
    my $m = $test ? 'get' : 'get_ok';

    for my $from ( 1..10 ) {
        for my $to ( $from..10 ) {
            $self->mech->$m("/?from=$from;to=$to");
            if ( $test ) {
                my $result = from_json( $self->mech->content );
                is_deeply $result => [ $from..$to ];
            }
        }
    }
}

1;
