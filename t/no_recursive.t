use strict;
use warnings;
use Test::More tests => 9;

eval {
  package Inker;
  
  use Moo;
  with 'Role::IncHook::NoRecursive';
  sub Inker::INC {
    my($self, $filename) = @_;
    Test::More::note("filename = $filename");
    
    my $class = $filename;
    $class =~ s/\.pm$//;
    $class =~ s/\//::/g;

    Test::More::note("class = $class");
    
    open my $fh, '<', \"package $class; sub one { 1 }; 1";
    return $fh;
  }
};
diag $@ if $@;

my $inker = Inker->new;
isa_ok $inker, 'Inker';
ok eval { $inker->does('Role::IncHook::NoRecursive') }, "does Role::IncHook::NoRecursive";
eval $@ if $@;

ok eval { $inker->can('INC') }, "can INC";
eval $@ if $@;;

push @INC, Inker->new;

ok !$INC{'Foo/Bar/Baz.pm'}, "Foo::Bar::Baz not loaded";

ok eval 'use Foo::Bar::Baz; 1';
diag $@ if $@;

is Foo::Bar::Baz->one, 1, 'Foo::Bar::Baz->one = 1';

ok $INC{'Foo/Bar/Baz.pm'}, "Foo::Bar::Baz not loaded";

ok eval 'require Boo::Bar::Bum';
diag $@ if $@;

is Boo::Bar::Bum->one, 1, 'Boo::Bar::Bum->one = 1';
