#!/usr/bin/env perl
# Copyright 2024 WebPros International, LLC
# All rights reserved.
# copyright@cpanel.net http://cpanel.net
# This code is subject to the cPanel license. Unauthorized copying is prohibited.

package ea_php::find_latest_version;

use strict;
use warnings;

use FindBin;
use lib "../ea-tools/lib/ea4_tool";    # assumes ea-tools is checked out next to this repo
use ea4_tool::util ();
use Cwd;
use File::Slurp;

use Data::Dumper;

my $http = ea4_tool::util::http ();

my $res = $http->get("https://api.github.com/repos/vmware-labs/mod_wasm/releases");
my $ref = ea4_tool::util::json2ref ($res->{content});

sub extract_version {
    my ($version) = @_;

    if ($version =~ m/^v(\d+)\.(\d+)\.(\d+)$/) {
        my ($major, $minor, $nano) = ($1, $2, $3);
        return ($major, $minor, $nano);
    }
    else {
        die "Unable to parse version :$version:";
    }
}

sub cmp_version {
    my ($versiona, $versionb) = @_;

    my ($major_a, $minor_a, $nano_a) = extract_version ($versiona);
    my ($major_b, $minor_b, $nano_b) = extract_version ($versiona);

    return 1 if ($major_a > $major_b);
    return -1 if ($major_a < $major_b);

    return 1 if ($minor_a > $minor_b);
    return -1 if ($minor_a < $minor_b);

    return 1 if ($nano_a > $nano_b);
    return -1 if ($nano_a < $nano_b);

    return 0;
}

# the versions are listed in key called tag_name as v0.12.2

my $best_ref;
my $best_version;

foreach my $xref (@{ $ref }) {
    if (!$best_ref) {
        # make sure it is a copy
        $best_ref = \ %{ $xref };
        $best_version = "$xref->{tag_name}";

        next;
    }

    my $ret = cmp_version ($best_version, $xref->{tag_name});
    if ($ret == 1) {
        # make sure it is a copy
        $best_ref = \ %{ $xref };
        $best_version = "$xref->{tag_name}";
    }
}

print "Upstream is " . $best_ref->{tag_name} . "\n";
my $version = substr ($best_ref->{tag_name}, 1);

# determine local version

my $spec_raw = File::Slurp::slurp ("SPECS/ea-apache24-mod-wasm.spec");
my @lines = split (/\n/, $spec_raw);

my $local_version;
foreach my $line (@lines) {
    if ($line =~ m/^Version: (.+)$/) {
        $local_version = $1;
        last;
    }
}

if ($local_version eq $version) {
    print "Version has not changed\n";
    exit 0;
}

# lets get the useful information

my $tarball = $best_ref->{tag_name} . ".tar.gz";

unlink ($tarball);
system ('wget', '-O', $tarball, $best_ref->{tarball_url});
my $result = `tar tf $tarball | head -n 1`;
chomp $result;

my $dirname = $best_ref->{tag_name};
system ("rm -rf $dirname");
mkdir $dirname;

my @cmd = ("tar", "xf", $tarball, "-C", $dirname, "--strip-components=1", "$result" . "LICENSE");
system (@cmd);

@cmd = ("tar", "xf", $tarball, "-C", $dirname, "--strip-components=1", "$result" . "README.md");
system (@cmd);

print Dumper ($best_ref->{assets});

my $cwd = getcwd ();
chdir $dirname;

foreach my $xref (@{ $best_ref->{assets} }) {
    next if ($xref->{name} ne "mod_wasm.so" && $xref->{name} ne "libwasm_runtime.so");

    my $name = $xref->{name};
    my $url = $xref->{browser_download_url};

    system ('wget', '-O', $name, "$url");
}

chdir $cwd;
unlink $tarball;

@cmd = ("tar", "czf", "SOURCES/$tarball", $dirname);
system (@cmd);

@cmd = ("rm", "-rf", $dirname);
system (@cmd);

print "New Version $version\n";
print "SOURCES/$tarball has been created\n";

