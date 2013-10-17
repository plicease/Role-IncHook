package Role::IncHook;

use strict;
use Moo::Role;
use warnings NONFATAL => 'all';

# ABSTRACT: Roles for use in writing @INC Hooks
# VERSION

requires 'INC';

1;
