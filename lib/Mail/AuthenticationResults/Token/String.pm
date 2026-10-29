package Mail::AuthenticationResults::Token::String;
# ABSTRACT: Class for modelling AuthenticationResults Header parts detected as strings

require 5.008;
use strict;
use warnings;
# VERSION
use Carp;

use base 'Mail::AuthenticationResults::Token';

=head1 DESCRIPTION

Token representing a string

=cut

sub is {
    my ( $self ) = @_;
    return 'string';
}

sub parse {
    my ($self) = @_;

    my $header = $self->{ 'header' };
    my $value = q{};

    croak 'Not a string' if $header =~ /^"/;
    croak 'Not a string' if $header =~ /^\(/;

    # Parse differently if we are post assignment (we are a value) or not (we are likely a key or key part)
    my $is_value = 0;
    my $is_first = 0;
    if ( exists ( $self->{ 'args' }->{ 'last_non_comment_type' } ) ) {
        if ( $self->{ 'args' }->{ 'last_non_comment_type' }->is() eq 'assignment' ) {
            if ( $self->{ 'args' }->{ 'last_non_comment_type' }->value() eq '=' ) {
                $is_value = 1;
            }
        }
    }
    else {
        $is_first = 1;
    }

    if ( $is_value || $is_first ) {
        $value = $1 if $header =~ /^([^\s;]+)/;
    }
    else {
        $value = $1 if $header =~ /^([^\s;"(=\/.]+)/;
    }

    croak 'Not a string' if $value eq q{};

    $header = substr( $header, length $value );

    $self->{ 'value' } = $value;
    $self->{ 'header' } = $header;

    return;
}

1;

