use strict;
use warnings;

package Path::IsDev;
BEGIN {
  $Path::IsDev::AUTHORITY = 'cpan:KENTNL';
}
{
  $Path::IsDev::VERSION = '0.6.0';
}

# ABSTRACT: Determine if a given Path resembles a development source tree





use Sub::Exporter -setup => { exports => [ is_dev => \&_build_is_dev, ], };

our $ENV_KEY_DEBUG = 'PATH_ISDEV_DEBUG';

our $DEBUG = ( exists $ENV{$ENV_KEY_DEBUG} ? $ENV{$ENV_KEY_DEBUG} : undef );


sub debug {
  return unless $DEBUG;
  return *STDERR->printf( qq{[Path::IsDev] %s\n}, shift );
}

sub _build_is_dev {
  my ( $class, $name, $arg ) = @_;

  my $object;
  return sub {
    my ($path) = @_;
    $object ||= do {
      require Path::IsDev::Object;
      Path::IsDev::Object->new( %{ $arg || {} } );
    };
    return $object->matches($path);
  };
}


*is_dev = _build_is_dev( 'Path::IsDev', 'is_dev', {} );

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Path::IsDev - Determine if a given Path resembles a development source tree

=head1 VERSION

version 0.6.0

=head1 SYNOPSIS

    use Path::IsDev qw(is_dev);

    if( is_dev('/some/path') ) {
        ...
    } else {
        ...
    }

=head1 DESCRIPTION

This module is more or less a bunch of heuristics for determining if a given path
is a development tree root of some kind.

This has many useful applications, notably ones that require behaviours for "installed"
modules to be different to those that are still "in development"

=head1 FUNCTIONS

=head2 debug

Debug callback.

To enable debugging:

    export PATH_ISDEV_DEBUG=1

=head2 C<is_dev>

Using an C<import>'ed C<is_dev>:

    if( is_dev( $path ) ) {

    }

Though the actual heuristics used will be based on how C<import> was called.

Additionally, you can call

    Path::IsDev::is_dev

without C<import>ing anything, and it will behave exactly the same as if you'd imported
it using

    use Path::IsDev qw( is_dev );

That is, no C<set> specification is applicable, so you'll only get the "default".

=head1 UNDERSTANDING AND DEBUGGING THIS MODULE

Understanding how this module works, is critical to understand where you can use it, and the consequences of using it.

This module operates on a very simplistic level, and its easy for false-positives to occur.

There are two types of Heuristics, Postive/Confirming Heuristics, and Negative/Disconfirming Heuristics.

Positive Heuristics and Negative Heuristics are based solely on the presence of specific marker files in a directory, or special marker directories.

For instance, the files C<META.yml>, C<Makefile.PL>, and C<Build.PL> are all B<Positive Heuristic> markers, because their presence
often indicates a "root" of a development tree.

And for instance, the directories C<t/>, C<xt/> and C<.git/> are also B<Positive Heuristic> markers, because these structures
are common in C<perl> development trees, and uncommon in install trees.

However, these markers sometimes go wrong, for instance, consider you have a C<local::lib> or C<perlbrew> install in C<$HOME>

    $HOME/
    $HOME/lib/
    $HOME/perl5/perls/perl-5.19.3/lib/site_perl/

Etc.

Under normal circumstances, neither C<$HOME> nor those 3 paths are considered C<dev>.

However, all it takes to cause a false positive, is for somebody to install a C<t> or C<xt> directory, or a marker file in one of the
above directories for C<path_isdev($dir)> to return true.

This may not be a problem, at least, until you use C<Path::FindDev> which combines C<Path::IsDev> with recursive up-level traversal.

    $HOME/
    $HOME/lib/
    $HOME/perl5/perls/perl-5.19.3/lib/site_perl/

    find_dev('$HOME/perl5/perls/perl-5.19.3/lib/site_perl/') # returns false, because it is not inside a dev directory

    mkdir $HOME/t

    find_dev('$HOME/perl5/perls/perl-5.19.3/lib/site_perl/') # returns $HOME, because $HOME/t exists.

And it is this kind of problem that usually catches people off guard.

    PATH_ISDEV_DEBUG=1 perl -Ilib -MPath::FindDev=find_dev -E "say find_dev(q{/home/kent/perl5/perlbrew/perls/perl-5.19.3/lib/site_perl})"

    [Path::IsDev=0] {
    [Path::IsDev=0]  set               => Basic
    [Path::IsDev=0]  set_prefix        => Path::IsDev::HeuristicSet
    [Path::IsDev=0]  set_module        => Path::IsDev::HeuristicSet::Basic
    [Path::IsDev=0]  loaded_set_module => Path::IsDev::HeuristicSet::Basic
    [Path::IsDev=0] }
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3/lib/site_perl
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3/lib
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent
    [Path::IsDev=0] /home/kent/META.yml exists for Path::IsDev::Heuristic::META
    [Path::IsDev=0] ::META matched path /home/kent
    /home/kent

Whoops!.

    [Path::IsDev=0] /home/kent/META.yml exists for Path::IsDev::Heuristic::META

No wonder!

    rm /home/kent/META.yml

    PATH_ISDEV_DEBUG=1 perl -Ilib -MPath::FindDev=find_dev -E "say find_dev(q{/home/kent/perl5/perlbrew/perls/perl-5.19.3/lib/site_perl})"
    [Path::IsDev=0] {
    [Path::IsDev=0]  set               => Basic
    [Path::IsDev=0]  set_prefix        => Path::IsDev::HeuristicSet
    [Path::IsDev=0]  set_module        => Path::IsDev::HeuristicSet::Basic
    [Path::IsDev=0]  loaded_set_module => Path::IsDev::HeuristicSet::Basic
    [Path::IsDev=0] }
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3/lib/site_perl
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3/lib
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent
    [Path::IsDev=0] /home/kent/t exists for::TestDir
    [Path::IsDev=0] ::TestDir matched path /home/kent

Double whoops!

    [Path::IsDev=0] /home/kent/t exists for::TestDir

And you could keep doing that until you rule out all the bad heuristics in your tree.

Or, you could use a negative heuristic.

    touch /home/kent/.path_isdev_ignore

    PATH_ISDEV_DEBUG=1 perl -Ilib -MPath::FindDev=find_dev -E "say find_dev(q{/home/kent/perl5/perlbrew/perls/perl-5.19.3/lib/site_perl})"
    [Path::IsDev=0] {
    [Path::IsDev=0]  set               => Basic
    [Path::IsDev=0]  set_prefix        => Path::IsDev::HeuristicSet
    [Path::IsDev=0]  set_module        => Path::IsDev::HeuristicSet::Basic
    [Path::IsDev=0]  loaded_set_module => Path::IsDev::HeuristicSet::Basic
    [Path::IsDev=0] }
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3/lib/site_perl
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3/lib
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls/perl-5.19.3
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew/perls
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5/perlbrew
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent/perl5
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home/kent
    [Path::IsDev=0] /home/kent/.path_isdev_ignore exists for Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile
    [Path::IsDev=0] Negative ::IsDev::IgnoreFile excludes path /home/kent
    [Path::IsDev=0] no match found
    [Path::IsDev=0] Matching /home
    [Path::IsDev=0] no match found

Success!

    [Path::IsDev=0] Matching /home/kent
    [Path::IsDev=0] /home/kent/.path_isdev_ignore exists for Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile
    [Path::IsDev=0] Negative ::IsDev::IgnoreFile excludes path /home/kent

=head1 HEURISTICS

=head2 Negative Heuristics bundled with this distribution

Just remember, a B<Negative> Heuristic B<excludes the path it is associated with>

=over 4

=item * L<< C<IsDev::IgnoreFile>|Path::IsDev::NegativeHeuristic::IsDev::IgnoreFile >> - C<.path_isdev_ignore>

=back

=head2 Positive Heuristics bundled with this distribution

=over 4

=item * L<< C<Changelog>|Path::IsDev::Heuristic::Changelog >> - Files matching C<Changes>, C<Changelog>, and similar, case insensitive, extensions optional.

=item * L<< C<DevDirMarker>|Path::IsDev::Heuristic::DevDirMarker >> - explicit C<.devdir> file to indicate a project root.

=item * L<< C<META>|Path::IsDev::Heuristic::META >> - C<META.yml>/C<META.json>

=item * L<< C<MYMETA>|Path::IsDev::Heuristic::MYMETA >> - C<MYMETA.yml>/C<MYMETA.json>

=item * L<< C<Makefile>|Path::IsDev::Heuristic::Makefile >> - Any C<Makefile> format documented supported by GNU Make

=item * L<< C<TestDir>|Path::IsDev::Heuristic::TestDir >> - A directory called either C<t/> or C<xt/>

=item * L<< C<Tool::DZil>|Path::IsDev::Heuristic::Tool::DZil >> - A C<dist.ini> file

=item * L<< C<Tool::MakeMaker>|Path::IsDev::Heuristic::Tool::MakeMaker >> - A C<Makefile.PL> file

=item * L<< C<Tool::ModuleBuild>|Path::IsDev::Heuristic::Tool::ModuleBuild >> - A C<Build.PL> file

=item * L<< C<VCS::Git>|Path::IsDev::Heuristic::VCS::Git >> - A C<.git> directory

=back

=head1 HEURISTIC SETS

=head2 Heuristic Sets Bundled with this distribution

=over 4

=item * L<< C<Basic>|Path::IsDev::HeuristicSet::Basic >> - The basic heuristic set that contains most, if not all heuristics.

=back

=head1 ADVANCED USAGE

=head2 Custom Sets

C<Path::IsDev> has a system of "sets" of Heuristics, in order to allow for pluggable
and flexible heuristic types.

Though, for the vast majority of cases, this is not required.

    use Path::IsDev is_dev => { set => 'Basic' };
    use Path::IsDev is_dev => { set => 'SomeOtherSet' , -as => 'is_dev_other' };

=head2 Overriding the default set

If for whatever reason the C<Basic> set is insufficient, or if it false positives on your system for some reason,
the "default" set can be overridden.

    export PATH_ISDEV_DEFAULT_SET="SomeOtherSet"

    ...
    use Path::IsDev qw( is_dev );
    is_dev('/some/path') # uses SomeOtherSet

Though this will only take priority in the event the set is not specified during C<import>

If this poses a security concern for the user, then this security hole can be eliminated by declaring the set you want in code:

    export PATH_ISDEV_DEFAULT_SET="SomeOtherSet"

    ...
    use Path::IsDev  is_dev => { set => 'Basic' };
    is_dev('/some/path') # uses Basic, regardless of ENV

=head1 SECURITY

Its conceivable, than an evil user could construct an evil set, containing arbitrary and vulnerable code,
and possibly stash that evil set in a poorly secured privileged users @INC

And if they managed to achieve that, if they could poison the privileged users %ENV, they could trick the privileged user into executing arbitrary code.

Though granted, if you can do either of those 2 things, you're probably security vulnerable anyway, and granted, if you could do either of those 2 things you could do much more evil things by the following:

    export PERL5OPT="-MEvil::Module"

So with that in understanding, saying this modules default utility is "insecure" is mostly a bogus argument.

And to that effect, this module does nothing to "lock down" that mechanism, and this module encourages you
to B<NOT> force a set, unless you B<NEED> to, and strongly suggests that forcing a set for the purpose of security will achieve no real improvement in security, while simultaneously reducing utility.

=begin MetaPOD::JSON v1.1.0

{
    "namespace":"Path::IsDev",
    "interface":"exporter"
}


=end MetaPOD::JSON

=head1 AUTHOR

Kent Fredric <kentfredric@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Kent Fredric <kentfredric@gmail.com>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
