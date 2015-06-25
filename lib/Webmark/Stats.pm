package Webmark::Stats;

use 5.20.0;

use strict;
use warnings;

use Moose;

has $_ => (
    traits => [ 'Counter' ],
    isa => 'Num',
    is => 'rw',
    default => 0,
    handles => { "inc_$_" => 'inc' },
) for qw/ nbr sum sum_square /;

has $_ => (
    is => 'rw',
    predicate => "has_$_"
) for qw/ min max/;

sub record {
    my( $self, $num ) = @_;
    $self->inc_nbr;
    $self->inc_sum($num);
    $self->inc_sum_square($num**2);
    $self->min($num) if !$self->has_min or $self->min > $num;
    $self->max($num) if !$self->has_max or $self->max < $num;
}

sub mean {
    my $self = shift;
    $self->sum / $self->nbr;
}

sub std_dev {
    my $self = shift;
    sqrt((( $self->sum_square/$self->nbr)- $self->mean ** 2) / ( $self->nbr -1 ) ) / $self->mean;
}

sub report {
    my $self = shift;
    say "nbr observations: ", $self->nbr;
    say "mean: ", $self->mean;
    say "std dev: ", 100 * $self->std_dev, "%";
    say "min/max: ", join ' ', map { $self->$_ } qw/ min max /;
}

sub as_hashref {
    my $self = shift;
    
    return {
        map { $_ => $self->$_ } qw/ nbr min max mean std_dev /
    }
}
1;



