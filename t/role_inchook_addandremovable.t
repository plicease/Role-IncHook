use strict;
use warnings;
use Test::More tests => 2;

sub usebad_ok
{
  my $class = shift;
  eval qq{ use $class; };
  my $error = $@;
  like $error, qr{Can't locate}, "usebad $class;";
}

foreach my $impl (qw( Moose Moo ))
{
  subtest $impl => sub {
    local @INC = @INC;
  
    plan skip_all => "test requires $impl" unless eval q{ require "$impl.pm"; 1 };
    my $code = q{
      package Inker::IMPLEMENTATION;
      use IMPLEMENTATION;
      with 'Role::IncHook::AddAndRemovable';
      sub Inker::IMPLEMENTATION::INC {
        my($self, $file) = @_;
        my $class = $file;
        $class =~ s/\.pm$//;
        $class =~ s/\//::/g;
        Test::More::note("class = $class");
        if($class =~ /^Foo::/)
        {
          open my $fh, '<', \'1;';
          return $fh;
        }
        return;
      }
    };
    $code =~ s/IMPLEMENTATION/$impl/g;
    eval $code;

    my $class = "Inker::$impl";
    
    do {
      my $error = $@;
      is $error, '', "create class $class";
      return if $error;
    };

    my $inker = $class->new;
    isa_ok $inker, $class;

    return unless defined $inker;
    
    usebad_ok "Foo::Bar1::$impl";
    ok !$inker->is_hooked, 'is not hooked';

    $inker->unshift_hook;
    
    use_ok "Foo::Bar2::$impl";
    ok $inker->is_hooked, 'is hooked';
    
    $inker->unhook;

    usebad_ok "Foo::Bar3::$impl";
    ok !$inker->is_hooked, 'is not hooked';
    
    $inker->push_hook;
    
    use_ok "Foo::Bar4::$impl";
    ok $inker->is_hooked, 'is hooked';
    
  };
}


