package Role::NonRecursiveIncHook;

use strict;
use Moo::Role;
use warnings NONFATAL => 'all';

# ABSTRACT: Role that adds a @INC hook without recursing infinitely
# VERSION

requires 'INC';

1;
