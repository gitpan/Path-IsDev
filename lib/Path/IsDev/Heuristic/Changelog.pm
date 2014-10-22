use strict;
use warnings;

package Path::IsDev::Heuristic::Changelog;
BEGIN {
  $Path::IsDev::Heuristic::Changelog::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::Changelog::VERSION = '1.000002';
}

# ABSTRACT: Determine if a path contains a C<Changelog> (or similar)



use Role::Tiny::With;
with 'Path::IsDev::Role::Heuristic', 'Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File';


sub basename_regexp {
  return qr/\AChange(s|log)(|[.][^.\s]+)\z/isxm;
}


sub matches {
  my ( $self, $result_object ) = @_;
  if ( $self->child_basename_matchregexp_file( $result_object, $self->basename_regexp ) ) {
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

Path::IsDev::Heuristic::Changelog - Determine if a path contains a C<Changelog> (or similar)

=head1 VERSION

version 1.000002

=head1 DESCRIPTION

This heuristic matches any case variation of C<Changes> or C<Changelog>,
including any files of that name with a suffix.

e.g.:

    Changes
    CHANGES
    Changes.mkdn

etc.

=head1 METHODS

=head2 C<basename_regexp>

Indicators for this heuristic is the existence of a file such as:

    Changes             (i)
    Changes.anyext      (i)
    Changelog           (i)
    Changelog.anyext    (i)

=head2 C<matches>

Returns a match if any child of C<path> exists matching the regexp C<basename_regexp>

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::Changelog",
    "interface":"single_class",
    "does":[ "Path::IsDev::Role::Heuristic", "Path::IsDev::Role::Matcher::Child::BaseName::MatchRegexp::File" ]
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
