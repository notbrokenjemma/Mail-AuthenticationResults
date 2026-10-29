package Mail::AuthenticationResults::Token::QuotedString;
# ABSTRACT: Class for modelling AuthenticationResults Header parts detected as quoted strings

require 5.008;
use strict;
use warnings;
# VERSION
use Carp;

use base 'Mail::AuthenticationResults::Token';

=head1 DESCRIPTION

Token representing a quoted string

=cut

sub is {
    my ( $self ) = @_;
    return 'string';
}

sub parse {
    my ($self) = @_;

    my $header = $self->{ 'header' };
    my $value = q{};

    my $first = substr( $header,0,1 );
    croak 'not a quoted string' if $first ne '"';

    my $end = index( $header, '"', 1 );
    croak 'Quoted string not closed' if $end == -1;

    $value  = substr( $header, 1, $end - 1 );
    $header = substr( $header, $end + 1 );

    $self->{ 'value' } = $value;
    $self->{ 'header' } = $header;

    return;
}

1;

