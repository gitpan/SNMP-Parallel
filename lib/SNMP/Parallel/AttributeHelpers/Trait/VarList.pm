package SNMP::Parallel::AttributeHelpers::Trait::VarList;

=head1 NAME

SNMP::Parallel::AttributeHelpers::Trait::VarList

=cut

use Moose::Role;
use MooseX::AttributeHelpers;
use SNMP::Parallel::AttributeHelpers::MethodProvider::VarList;

with 'MooseX::AttributeHelpers::Trait::Collection::Array';

=head1 ATTRIBUTES

=head2 method_provider

 $str = $self->method_provider;

=cut

has method_provider => (
    is => 'ro',
    isa => 'ClassName',
    predicate => 'has_method_provider',
    default => 'SNMP::Parallel::AttributeHelpers::MethodProvider::VarList',
);

=head1 METHODS

=head2 _process_options

Set default options unless specified.

 {
   is => 'ro',
   isa => 'ArrayRef',
   default => [],
 }

=cut

before _process_options => sub {
    my($class, $name, $options) = @_;

    $options->{'is'}      ||= 'ro';
    $options->{'isa'}     ||= 'ArrayRef';
    $options->{'default'} ||= sub { [] };
};

=head1 SEE ALSO

L<SNMP::Parallel::AttributeHelpers::MethodProvider::VarList>

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

=head1 AUTHOR

See L<SNMP::Parallel>.

=cut

1;
