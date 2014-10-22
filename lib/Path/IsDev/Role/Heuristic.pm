use strict;
use warnings;

package Path::IsDev::Role::Heuristic;
BEGIN {
  $Path::IsDev::Role::Heuristic::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::Heuristic::VERSION = '0.6.0';
}

# ABSTRACT: Base role for Heuristic things.

use Role::Tiny;


sub _blessed { require Scalar::Util; goto &Scalar::Util::blessed }


sub name {
  my $name = shift;
  $name = _blessed($name) if _blessed($name);
  $name =~ s/\APath::IsDev::Heuristic:/:/msx;
  return $name;
}


requires 'matches';

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::Heuristic - Base role for Heuristic things.

=head1 VERSION

version 0.6.0

=head1 ROLE REQUIRES

=head2 C<matches>

Implementing roles must provide this method.

    return : 1 / undef
             1     -> this path is a development directory as far as this heuristic is concerned
             undef -> this path is not a development directory as far as this heuristic is concerned

    args : ( $class , $result_object )
        $class         -> method will be invoked on packages, not objects
        $result_object -> will be a Path::IsDev::Result

=head1 METHODS

=head2 C<name>

Returns the name to use in debugging.

By default, this is derived from the classes name
with the C<PIDH> prefix removed:

    Path::IsDev::Heuristic::Tool::Dzil->name() # → ::Tool::Dzil

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Heuristic",
    "interface":"role"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
