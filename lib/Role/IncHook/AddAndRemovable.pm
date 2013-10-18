package Role::IncHook::AddAndRemovable;

use strict;
use Moo::Role;
use warnings NONFATAL => 'all';
use Scalar::Util qw( refaddr );

# ABSTRACT: Role for an @INC hook with hook and unhook methods
# VERSION

=head1 SYNOPSIS

Your hook class defined:

 package My::IncHook;
 
 use Moo; # or Moose
 with 'Role::IncHook::AddAndRemovable';
 
 # note: must be fully qualified
 sub My::IncHook::Removable::INC
 {
   my($self, $filename) = @_;
   ...
 }

Your hook class used:

 use My::InkHook;
 
 my $hook = My::InkHook->new;
 
 $hook->push_hook;
 
 # My::IncHook is active
 
 $hook->unhook
 
 # My::IncHook is no longer active

=head1 DESCRIPTION

This role adds methods to activate, remove an @INC hook class.

=head1 METHODS

=head2 INC

You definte this method in your class.  See L<perlfunc#require> for details.

=cut

requires 'INC';

=head2 unshift_hook

 $hook->unshift_hook;

Activate the hook, placing it at the beginning of the @INC list.

=cut

sub unshift_hook
{
  my($self) = @_;
  unshift @INC, $self;
  $self;
}

=head2 push_hook

 $hook->push_hook;

Activate the hook, placing it at the end of the @INC list.

=cut

sub push_hook
{
  my($self) = @_;
  push @INC, $self;
  $self;
}

=head2 unhook

 $hook->unhook;

Remove the hook from @INC, for each time it appears in the @INC list.

=cut

sub unhook
{
  my($self) = @_;
  @INC = grep { !ref($_) || refaddr($_) != refaddr($self) } @INC;
  $self;
}

=head2 is_hooked

 my $book = $hook->is_hooked;

Returns true if the hook is activated.

=cut

sub is_hooked
{
  my($self) = @_;
  foreach my $inc (@INC)
  {
    return $inc if ref($inc) && refaddr($inc) == refaddr($self);
  }
  return;
}

1;

=head1 SEE ALSO

=over 4

=item

L<Role::IncHook>

=item

L<Role::IncHook::NoRecursion>

=back

=cut
