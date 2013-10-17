use strict;
use warnings;
use Test::More tests => 2;

foreach my $impl (qw( Moo Moose ))
{
  subtest $impl => sub {
    plan skip_all => "test requires $impl" unless eval q{ require "$impl.pm"; 1 };
    plan tests => 10;

    my $code = q{
      package Inker::IMPLEMENTATION;
  
      use IMPLEMENTATION;
      with 'Role::IncHook::NoRecursion';
      sub Inker::IMPLEMENTATION::INC {
        my($self, $filename) = @_;
        
        my $class = $filename;
        $class =~ s/\.pm$//;
        $class =~ s/\//::/g;

        Test::More::note("filename = $filename");    
        Test::More::note("class    = $class");
        return unless $filename =~ /^[FB]oo\//;
    
        if($class =~ /^Foo::Recursive::${impl}::(\d+)$/)
        {
          my $num = $1;
          my $next = $num+1;
          
          die "deep recursion!" if $num == 5;
          
          open my $fh, '<', \"package Foo::Recursive::${impl}::$1; use Foo::Recursive::${impl}::$next; 1;";
          return $fh;
        }
    
        open my $fh, '<', \"package $class; sub one { 1 }; 1";
        return $fh;
      }
    };
    $code =~ s/IMPLEMENTATION/$impl/g;
    eval $code;
    diag $@ if $@;

    my $inker = "Inker::$impl"->new;
    isa_ok $inker, "Inker::$impl";
    ok eval { $inker->does('Role::IncHook::NoRecursion') }, "does Role::IncHook::NoRecursion";
    eval $@ if $@;

    ok eval { $inker->can('INC') }, "can INC";
    eval $@ if $@;;

    note "\@INC before:";
    note "  $_" for @INC;

    local @INC = @INC;
    unshift @INC, $inker;

    note "\@INC after:";
    note "  $_" for @INC;

    ok !$INC{"Foo/Bar/Baz/$impl.pm"}, "Foo::Bar::Baz::$impl not loaded";

    ok eval "use Foo::Bar::Baz::$impl; 1";
    diag $@ if $@;

    is "Foo::Bar::Baz::$impl"->one, 1, "Foo::Bar::Baz::$impl->one = 1";

    ok $INC{"Foo/Bar/Baz/$impl.pm"}, "Foo::Bar::Baz::$impl not loaded";

    ok eval "require Boo::Bar::Bum::$impl";
    diag $@ if $@;

    is "Boo::Bar::Bum::$impl"->one, 1, "Boo::Bar::Bum::$impl->one = 1";
  
    eval qq{
      require Foo::Recursive::${impl}::1;
    };
    my $error = $@;
    
    unlike $error, qr{deep recursion}, "didn't die from deep recursion";
    note $error;
  }
}
