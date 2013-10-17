package Role::IncHook::NoRecursion;

use strict;
use Moo::Role;
use warnings NONFATAL => 'all';

# ABSTRACT: Role that adds a @INC hook without recursing infinitely
# VERSION

requires 'INC';

has already_including => (
  is      => 'rw',
  default => 0,
);

around INC => sub {
  my($orig, $self, $filename) = @_;
  return if $self->already_including;
  $self->already_including(1);
  my @ret = $orig->($self, $filename);
  $self->already_including(0);
  @ret;
};

1;
