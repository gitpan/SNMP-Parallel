package SNMP::Parallel::AttributeHelpers::MethodProvider::HostList;

=head1 NAME

SNMP::Parallel::AttributeHelpers::MethodProvider::HostList

=head1 DESCRIPTION

This module does the role
L<SNMP::Parallel::AttributeHelpers::MethodProvider::Hash>.

=cut

use Moose::Role;
use SNMP::Parallel::Host;

with 'MooseX::AttributeHelpers::MethodProvider::Hash';

=head1 METHODS

=head2 set

 $code = $attribute->set($reader, $writer);
 $host_obj = $self->$code(\%args);
 $host_obj = $self->$code($host_obj);

Add a new L<SNMP::Parallel::Host> object to list.

=cut

sub set : method {
    my($attr, $reader, $writer) = @_;
    my $super = MooseX::AttributeHelpers::MethodProvider::Hash::set(@_);

    return sub {
        my $self = shift;

        if(@_ == 2) {
            return $super->(@_);
        }
        elsif(ref $_[0] eq 'HASH') {
            return $super->($self,
                $_[0]->{'address'} => SNMP::Parallel::Host->new($_[0])
            );
        }
        elsif(blessed $_[0])  {
            return $super->($self, $_[0]->address => $_[0]);
        }
        else {
            confess "Unknown input: @_";
        }
    };
}

=head2 shift

 $code = $attribute->shift($reader, $writer);
 $host_obj = $self->$code;

Returns a semi-random host object from the hostlist.

=cut

sub shift : method {
    my($attr, $reader, $writer) = @_;

    return sub {
        my $hosts = $reader->($_[0]);
        my($key)  = keys %$hosts or return;
        return delete $hosts->{$key};
    }
}

=head1 SEE ALSO

L<SNMP::Parallel::AttributeHelpers::Trait::VarList>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

See L<SNMP::Parallel>.

=cut

1;
