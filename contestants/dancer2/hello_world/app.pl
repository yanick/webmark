#!/usr/bin/perl 

use strict;
use warnings;

use Dancer2;

get '/' => sub { 'hello world' };

dance;

1;



