package Role::IncHook;

use strict;
use Moo::Role;
use warnings NONFATAL => 'all';

# ABSTRACT: Roles for use in writing @INC Hooks
# VERSION

requires 'INC';

1;

=head1 SEE ALSO

=over 4

=item

L<only::latest>

=item

L<Devel::INC::Sorted>

=item

L<Array::Sticky::INC>

=back

=cut
