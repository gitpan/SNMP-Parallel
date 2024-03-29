package SNMP::Parallel::Callbacks;

=head1 NAME

SNMP::Parallel::Callbacks - SNMP callbacks

=head1 SYNOPSIS

See L<SNMP::Parallel>.

=head1 DESCRIPTION

This package contains default callback methods for L<SNMP::Parallel>.
These methods are called from within an L<SNMP> get/getnext/set/...
method and should handle the response from a SNMP client.

=cut

use strict;
use warnings;
use SNMP::Parallel;
use SNMP::Parallel::Utils qw/:all/;

=head1 CALLBACKS

=head2 set

This method is called after L<SNMP>.pm has completed it's C<set> call
on the C<$host>.

If you want to use SNMP SET, you have to build your own varbind:

 use SNMP::Parallel::Utils qw/varbind/;
 $effective->add( set => varbind($oid, $iid, $value, $type) );

=cut

SNMP::Parallel->add_snmp_callback(set => set => sub {
    my($self, $host, $req, $res) = @_;

    return 'timeout' unless(ref $res);

    for my $r (grep { ref $_ } @$res) {
        my $cur_oid = make_numeric_oid($r->name);
        $host->add_result($r, $cur_oid);
    }

    return '';
});

=head2 get

This method is called after L<SNMP>.pm has completed it's C<get> call
on the C<$host>.

=cut

SNMP::Parallel->add_snmp_callback(get => get => sub {
    my($self, $host, $req, $res) = @_;

    return 'timeout' unless(ref $res);

    for my $r (grep { ref $_ } @$res) {
        my $cur_oid = make_numeric_oid($r->name);
        $host->add_result($r, $cur_oid);
    }

    return '';
});

=head2 getnext

This method is called after L<SNMP>.pm has completed it's C<getnext> call
on the C<$host>.

=cut

SNMP::Parallel->add_snmp_callback(getnext => getnext => sub {
    my($self, $host, $req, $res) = @_;

    return 'timeout' unless(ref $res);

    for my $r (grep { ref $_ } @$res) {
        my $cur_oid = make_numeric_oid($r->name);
        $host->add_result($r, $cur_oid);
    }

    return '';
});

=head2 walk

This method is called after L<SNMP>.pm has completed it's C<getnext> call
on the C<$host>. It will continue sending C<getnext> requests, until an
OID branch is walked.

=cut

SNMP::Parallel->add_snmp_callback(walk => getnext => sub {
    my($self, $host, $req, $res) = @_;
    my $i = 0;

    return 'timeout' unless(ref $res);

    while($i < @$res) {
        my $splice = 2;

        if(my $r = $res->[$i]) {
            my($cur_oid, $ref_oid) = make_numeric_oid(
                                         $r->name, $req->[$i]->name
                                     );

            $r->[0] = $cur_oid;
            $splice--;

            if(defined match_oid($cur_oid, $ref_oid)) {
                $host->add_result($r, $ref_oid);
                $splice--;
                $i++;
            }
        }

        if($splice) {
            splice @$req, $i, 1;
            splice @$res, $i, 1;
        }
    }

    if(@$res) {
        $$host->getnext($res, [ 'walk', $self, $host, $req ]);
        return;
    }
    else {
        return '';
    }
});

=head1 DEBUGGING

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

See L<SNMP::Parallel>.

=cut

1;
