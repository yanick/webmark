#!/usr/bin/perl 

use strict;
use warnings;

use Dancer;

set serializer => 'JSON';

get '/' => sub {  
    return [
        param('from')..param('to')
    ]
};

get '/specs' => sub {
    return {
        dancer_version => $Dancer::VERSION
    };
};

dance;
