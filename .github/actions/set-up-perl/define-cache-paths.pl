use strict;
use warnings;
use autodie;

use Cwd qw( abs_path getcwd );

my $perl_version = shift @ARGV;
my $cache_extra  = shift @ARGV;

# Older Perls put `.` in @INC. Caching the current dir would stash the whole checkout in the cache,
# and restoring it would write stale files over the checkout.
my $cwd   = getcwd();
my @cache = grep {
    my $abs = abs_path($_);
    !( defined $abs && $abs eq $cwd )
} grep { !ref } @INC;

if ($cache_extra) {
    push @cache, "/opt/hostedtoolcache/perl/$perl_version/x64/$cache_extra";
}

my $cache = join q{}, map {"$_\n"} @cache;

open my $fh, '>>', $ENV{GITHUB_OUTPUT};
print {$fh} "cache-paths<<EOF-1\n$cache\nEOF-1\n"
    or die "Failed to write to $ENV{GITHUB_OUTPUT}: $!";
close $fh;

