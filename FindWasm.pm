# Copyright 2024 WebPros International, LLC
# All rights reserved.
# copyright@cpanel.net http://cpanel.net
# This code is subject to the cPanel license. Unauthorized copying is prohibited.

package FindWasm;

use strict;
use warnings;

use lib "../ea-tools/lib/ea4_tool";    # assumes ea-tools is checked out next to this repo
use ea4_tool::util ();

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

sub findBestCandidate {
    my $http = ea4_tool::util::http ();

    my $res = $http->get("https://api.github.com/repos/vmware-labs/mod_wasm/releases");
    my $ref = ea4_tool::util::json2ref ($res->{content});

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

    return ($best_ref, $best_version);
}

1;

