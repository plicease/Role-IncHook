package Role::IncHook::NoRecursion;

use strict;
use Moo::Role;
use warnings NONFATAL => 'all';

# ABSTRACT: Role that adds a @INC hook that won't accidentally recurse infinitely
# VERSION

=head1 SYNOPSIS

 package My::NonRecursiveIncHook;
 
 use Moo; # or Moose
 with 'Role::IncHook::NoRecursion';
 
 # note: must be fully qualified
 sub My::NonRecursiveIncHook::INC
 {
   my($self, $filename) = @_;
   require YAML; # doesn't induce infinite recursion
   print YAML::Dump({ filename => filename });
 }

=head1 DESCRIPTION

This role enforces logic that prevents your @INC hook from
accidentally causing infinite recursion.  Simply implement
your @INC hook as a class as described in the
L<require function's documentation|perlfunc#require> and
consume this role.  If recursing is detected while using
the @INC hook, on a particular module, it will skip it.

=cut

requires 'INC';

has _already_including => (
  is      => 'rw',
  default => 0,
);

around INC => sub {
  my($orig, $self, $filename) = @_;
  return if $self->_already_including;
  $self->_already_including(1);
  my @ret = $orig->($self, $filename);
  $self->_already_including(0);
  @ret;
};

1;

=head1 SEE ALSO

=over 4

=item

L<Role::IncHook>

=back

=cut
