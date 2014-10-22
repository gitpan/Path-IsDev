use strict;
use warnings;

package Path::IsDev::Heuristic::DevDirMarker;
BEGIN {
  $Path::IsDev::Heuristic::DevDirMarker::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Heuristic::DevDirMarker::VERSION = '0.4.0';
}

# ABSTRACT: Determine if a path contains a C<.devdir> file



use parent 'Path::IsDev::Heuristic';


sub files { return qw( .devdir ) }

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Heuristic::DevDirMarker - Determine if a path contains a C<.devdir> file

=head1 VERSION

version 0.4.0

=head1 DESCRIPTION

This Heuristic is a workaround that is likely viable in the event none of the other Heuristics work.

All this heuristic checks for is the presence of a special file called C<.devdir>, which is intended as an explicit notation that "This directory is a project root".

An example case where you might need such a Heuristic, is the scenario where you're not working
with a Perl C<CPAN> dist, but are instead working on a project in a different language, where Perl is simply there for build/test purposes.

=head1 METHODS

=head2 C<files>

Files relevant for this heuristic:

    .devdir

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Heuristic::TestDir",
    "interface":"single_class",
    "inherits":"Path::IsDev::Heuristic"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
