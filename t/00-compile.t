use strict;
use warnings;

# this test was generated with Dist::Zilla::Plugin::Test::Compile 2.037

use Test::More  tests => 27 + ($ENV{AUTHOR_TESTING} ? 1 : 0);



my @module_files = (
    'Path/IsDev.pm',
    'Path/IsDev/Heuristic/Changelog.pm',
    'Path/IsDev/Heuristic/DevDirMarker.pm',
    'Path/IsDev/Heuristic/META.pm',
    'Path/IsDev/Heuristic/MYMETA.pm',
    'Path/IsDev/Heuristic/Makefile.pm',
    'Path/IsDev/Heuristic/TestDir.pm',
    'Path/IsDev/Heuristic/Tool/Dzil.pm',
    'Path/IsDev/Heuristic/Tool/MakeMaker.pm',
    'Path/IsDev/Heuristic/Tool/ModuleBuild.pm',
    'Path/IsDev/Heuristic/VCS/Git.pm',
    'Path/IsDev/HeuristicSet/Basic.pm',
    'Path/IsDev/NegativeHeuristic/HomeDir.pm',
    'Path/IsDev/NegativeHeuristic/IsDev/IgnoreFile.pm',
    'Path/IsDev/NegativeHeuristic/PerlINC.pm',
    'Path/IsDev/Object.pm',
    'Path/IsDev/Result.pm',
    'Path/IsDev/Role/Heuristic.pm',
    'Path/IsDev/Role/HeuristicSet.pm',
    'Path/IsDev/Role/HeuristicSet/Simple.pm',
    'Path/IsDev/Role/Matcher/Child/BaseName/MatchRegexp.pm',
    'Path/IsDev/Role/Matcher/Child/BaseName/MatchRegexp/File.pm',
    'Path/IsDev/Role/Matcher/Child/Exists/Any.pm',
    'Path/IsDev/Role/Matcher/Child/Exists/Any/Dir.pm',
    'Path/IsDev/Role/Matcher/Child/Exists/Any/File.pm',
    'Path/IsDev/Role/Matcher/FullPath/Is/Any.pm',
    'Path/IsDev/Role/NegativeHeuristic.pm'
);



# no fake home requested

my $inc_switch = -d 'blib' ? '-Mblib' : '-Ilib';

use File::Spec;
use IPC::Open3;
use IO::Handle;

my @warnings;
for my $lib (@module_files)
{
    # see L<perlfaq8/How can I capture STDERR from an external command?>
    open my $stdin, '<', File::Spec->devnull or die "can't open devnull: $!";
    my $stderr = IO::Handle->new;

    my $pid = open3($stdin, '>&STDERR', $stderr, $^X, $inc_switch, '-e', "require q[$lib]");
    binmode $stderr, ':crlf' if $^O eq 'MSWin32';
    my @_warnings = <$stderr>;
    waitpid($pid, 0);
    is($?, 0, "$lib loaded ok");

    if (@_warnings)
    {
        warn @_warnings;
        push @warnings, @_warnings;
    }
}



is(scalar(@warnings), 0, 'no warnings found') if $ENV{AUTHOR_TESTING};


