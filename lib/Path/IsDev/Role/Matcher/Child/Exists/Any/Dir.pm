use strict;
use warnings;

package Path::IsDev::Role::Matcher::Child::Exists::Any::Dir;
BEGIN {
  $Path::IsDev::Role::Matcher::Child::Exists::Any::Dir::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::Role::Matcher::Child::Exists::Any::Dir::VERSION = '1.000000';
}

# ABSTRACT: Match if a path contains one of any of a list of directories


use Role::Tiny;
with 'Path::IsDev::Role::Matcher::Child::Exists::Any';


sub child_exists_dir {
  my ( $self, $result_object, $child ) = @_;

  my $child_path = $result_object->path->child($child);
  my $ctx        = { 'child_name' => $child, child_path => "$child_path", tests => [] };
  my $tests      = $ctx->{tests};

  if ( -d $child_path ) {
    push @{$tests}, { 'child_path_isdir?' => 1 };
    $result_object->add_reason( $self, 1, "$child_path is a dir", $ctx );
    return 1;
  }
  push @{$tests}, { 'child_path_isdir?' => 0 };
  $result_object->add_reason( $self, 0, "$child_path is not a dir", $ctx );

  return;
}


sub child_exists_any_dir {
  my ( $self, $result_object, @children ) = @_;
  for my $child (@children) {
    return 1 if $self->child_exists( $result_object, $child ) and $self->child_exists_dir( $result_object, $child );
  }
  return;
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev::Role::Matcher::Child::Exists::Any::Dir - Match if a path contains one of any of a list of directories

=head1 VERSION

version 1.000000

=head1 METHODS

=head2 C<child_exists_dir>

    $class->child_exists_dir( $result_object, $childname );

Return match if C<$childname> exists as a directory child of C<< $result_object->path >>,

=head2 C<child_exists_any_dir>

    $class->child_exists_any_dir( $result_object, @childnames );

Return match if any of C<@childnames> exist under C<< $result_object->path >> and are directories.

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev::Role::Matcher::Child::Exists::Any::Dir",
    "interface":"role",
    "does":"Path::IsDev::Role::Matcher::Child::Exists::Any"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
