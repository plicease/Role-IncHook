package Role::IncHook;

use 5.014;
use Moo::Role;

# ABSTRACT: Roles for use in writing @INC Hooks
# VERSION

=head1 SYNOPSIS

create a hook class:

 package My::IncHook;
 
 use Moo; # or Moose
 with 'Role::IncHook';
 
 # note: must be fully qualified
 sub My::IncHook::INC
 {
   my($self, $filename) = @_;
   # just warn when new modules are
   # requested, but leave the actual
   # loading to the normal perl @INC
   # machinery
   warn "requested $filename";
   return;
 }

use that hook:

 use My::IncHook;
 
 # use hook first (ie, warn for every request)
 unshift @INC, My::IncHook->new;
 
 # use hook last (ie, warn only when file is not found)
 push @INC, My::IncHook->new;

=head1 DESCRIPTION

The distribution C<Role-IncHook> provides roles that are
useful in writing @INC hooks for fun and profit.  The main
module for this distribution, documented here only requires
that your class implement an C<INC> method, the bare minimum
requirement for a @INC hook.

=cut

requires 'INC';

1;

=head2 Related Roles

=over 4

=item

L<Role::IncHook::NoRecursion>

An @INC hook role that aggressively avoids unintended recursion.

=item

L<Role::IncHook::AddAndRemovable>

An @INC hook role with methods to activate and remove the @INC hook.

=back

=head1 SEE ALSO

Here is a collection of documentation on @INC, some examples of
@INC hooks being used on CPAN, and tools related to @INC and
@INC hooks.

=over 4

=item

L<require|perlfunc#require>

The documentation for the Perl built-in C<require> includes information
on implementing an @INC hook (either as a callback function or a class).

=item

L<@INC|perlvar#INC>

Description of @INC itself to which you will be hooking into.

=item

L<only::latest>

An @INC hook implemented as a compile time pragma that forces the latest
version of a module to be loaded regardless of where it appears in the
@INC list.

=item

L<Devel::Hide>

This module hides one or more modules, which is handy for testing code which needs
to work without certain modules when they are already installed on your Perl.
This is implemented using an @INC hook.

=item

L<Log::Log4perl::Resurrector>

This module converts commented out L<Log::Log4perl> statements in Perl code (using
a special syntax) into uncommented L<Log::Log4perl> statements.  It is handy for 
including L<Log::Log4perl> in a module without making it a dependency.  This is implemented
using an @INC hook.

=item

L<Test::Clustericious::Cluster>

This module (among other things) adds an @INC hook to your test script which allows you
to specify modules in the C<__DATA__> section of your test.  This allows tests the loading
of modules, while the test itself remains self contained.

=item

L<Devel::INC::Sorted>

Module that keeps @INC sorted allowing you to keep certain hooks at the beginning of @INC.

=item

L<Array::Sticky::INC>

This module keeps the first entry in the @INC array at the beginning so that your @INC hook
can't be replaced by something else.

=back

If you have useful @INC hook documentation or interesting examples that aren't listed here,
please let me know, and I will add it.

=cut
