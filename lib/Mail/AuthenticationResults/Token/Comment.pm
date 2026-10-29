package Mail::AuthenticationResults::Token::Comment;
# ABSTRACT: Class for modelling AuthenticationResults Header parts detected as comments

require 5.008;
use strict;
use warnings;
# VERSION
use Carp;

use base 'Mail::AuthenticationResults::Token';

=head1 DESCRIPTION

Token representing a comment

=cut

sub is {
    my ( $self ) = @_;
    return 'comment';
}

sub parse {
    my ($self) = @_;

    my $header = $self->{ 'header' };
    my $value = q{};
    my $depth = 0;

    my $first = substr( $header,0,1 );
    if ( $first ne '(' ) {
        croak 'Not a comment';
    }

    my $end;
    while ( $header =~ /([()])/g ) {
        if ( $1 eq '(' ) {
            $depth++;
        }
        else {
            $depth--;
            if ( $depth == 0 ) {
                $end = pos( $header );
                last;
            }
        }
    }

    if ( $depth != 0 ) {
        croak 'Mismatched parens in comment';
    }

    $value  = substr( $header, 1, $end - 2 );
    $header = substr( $header, $end );

    $self->{ 'value' } = $value;
    $self->{ 'header' } = $header;

    return;
}

1;

