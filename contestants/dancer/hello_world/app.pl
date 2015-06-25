#!/usr/bin/perl 

use strict;
use warnings;

use Dancer;

set serializer => 'JSON';

get '/' => sub { 'hello world' };

get '/specs' => sub {
    return {
        dancer_version => $Dancer::VERSION
    };
};

dance;
