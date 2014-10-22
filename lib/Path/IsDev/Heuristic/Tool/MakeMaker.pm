use strict;
use warnings;

package Path::IsDev::Heuristic::Tool::MakeMaker;
BEGIN {
  $Path::IsDev::Heuristic::Tool::MakeMaker::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::Tool::MakeMaker::VERSION = '1.000001';
}


# ABSTRACT: Determine if a path is an C<EUMM> Tooled source directory

use Role::Tiny::With qw( with );
with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::Exists::Any::File';


sub files { return qw( Makefile.PL ) }


sub matches {
  my ( $self, $result_object ) = @_;
  if ( $self->child_exists_any_file( $result_object, $self->files ) ) {
    $result_object->result(1);
    return 1;
  }
  return;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Path::IsDev::Heuristic::Tool::MakeMaker - Determine if a path is an C<EUMM> Tooled source directory

=head1 VERSION

version 1.000001

=head1 METHODS

=head2 C<files>

Files relevant to this heuristic:

    Makefile.PL

=head2 C<matches>

Matches if any of the files in C<files> exist as children of the C<path>

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Tool::MakeMaker",
    "interface":"single_class",
    "does":[
        "Path::IsDev::Role::Heuristic",
        "Path::IsDev::Role::Matcher::Child::Exists::Any::File"
    ]
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
