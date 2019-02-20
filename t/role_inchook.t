use strict;
use warnings;
use Test::More;

foreach my $impl (qw( Moo Moose ))
{
  subtest $impl => sub {
    plan skip_all => "test requires $impl" unless eval q{ require "$impl.pm"; 1 };
    my $class = "Foo::$impl";
    eval qq{
      package $class;
      use $impl;
      with 'Role::IncHook';
      sub ${class}::INC { }
    };
    diag $@ if $@;
  
    my $obj = eval { $class->new };
    diag $@ if $@;
    isa_ok $obj, $class;
  };
}  

done_testing;
