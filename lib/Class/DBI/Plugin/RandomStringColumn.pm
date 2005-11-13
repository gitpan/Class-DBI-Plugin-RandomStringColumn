package Class::DBI::Plugin::RandomStringColumn;
use strict;
use warnings;
use vars qw($VERSION);
$VERSION = '0.05';

use String::Random qw//;

sub import {
    my $class = shift;
    my $pkg   = caller(0);
    
    no strict 'refs';
    *{"$pkg\::random_string_column"} = \&random_string_column;
}

sub random_string_column {
    my $class  = shift;
    my $column = shift or die "USAGE : use $class qw(column)";
    my $length = shift || 32;
    my $solt   = shift || '[A-Za-z0-9]';

    my $random = String::Random->new;

    $class->add_trigger(before_create => sub {
        my $self = shift;
        my %args = @_;
        
        return if $self->{$column};

        my $val;
        do { # must be unique
            $val = $random->randregex(sprintf('%s{%d}', $solt , $length));
        } while ($class->search($column => $val));

        $self->{$column} = $val;
    });
}

1;
__END__

=head1 NAME

Class::DBI::Plugin::RandomStringColumn - Random string column generator for Class::DBI

=head1 SYNOPSIS

  package Foo;
  use base qw(Class::DBI);
  use Class::DBI::Plugin::RandomStringColumn;
  __PACKAGE__->set_db(('Main', "dbi:SQLite:dbname=db/foo.sqlite", '', '', { AutoCommit => 1 });
  __PACKAGE__->table('foo');
  __PACKAGE__->columns(Primary => qw(session_id));
  __PACKAGE__->columns(All     => qw(number rand_id session_id));
  __PACKAGE__->random_string_column('rand_id', 3, '[0-9]');
  __PACKAGE__->random_string_column('session_id');

=head1 DESCRIPTION

Class::DBI::Plugin::RandomStringColumn is a plugin for Class::DBI, which generates 
random string column on create.

=head1 METHODS

=over 4

=item random_string_column

  __PACKAGE__->random_string_column(COLUMN_NAME, LENGTH, REGEXP);

REGEXP only support 'Character classes', likes '[A-Z]'.
Please note REGEXP is an string.

=head1 AUTHOR

MATSUNO Tokuhiro E<lt>tokuhiro at mobilefactory.jpE<gt>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 DEPENDENCIES

L<String::Random>

=head1 SEE ALSO

L<Class::DBI>

=cut
