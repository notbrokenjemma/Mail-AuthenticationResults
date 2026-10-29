package Mail::AuthenticationResults::Token;
# ABSTRACT: Base class for modelling AuthenticationResults Header parts

require 5.008;
use strict;
use warnings;
# VERSION
use Carp;

=head1 DESCRIPTION

Classes representing a tokenised Authentication Results Header, used in parsing

=method new( $header, $args )

Return a new Token object parsed from the given $header string using $args

$args value depend on the subclass of Token used, possible types are

L<Mail::AuthenticationResults::Token::Assignment> an assignment operator
L<Mail::AuthenticationResults::Token::Comment> a comment
L<Mail::AuthenticationResults::Token::QuotedString> a quoted string
L<Mail::AuthenticationResults::Token::Separator> a separator
L<Mail::AuthenticationResults::Token::String> a string

=cut

sub new {
    my ( $class, $header, $args ) = @_;

    my $self = { 'args' => $args };
    bless $self, $class;

    $self->{ 'header' } = $header;
    $self->parse();

    return $self;
}

=method new_from_value( $value )

Create a new token from the given value

=cut

sub new_from_value {
    my ( $class, $value ) = @_;

    my $self = { 'value' => $value };
    bless $self, $class;

    return $self;
}

=method value()

Return the value of the current Token instance.

=cut

sub value {
    my ( $self ) = @_;
    return $self->{ 'value' };
}

=method remainder()

Return the remainder of the header string after parsing the current token out.

Tokens created by L<Mail::AuthenticationResults::Parser> do not retain the
remainder once it has been consumed, and will return undef. Retaining a copy
of the remaining header in every token uses memory quadratic in the number
of tokens.

=cut

sub remainder {
    my ( $self ) = @_;
    return $self->{ 'header' };
}

=method parse()

Run the parser on the current $header and set up value() and remainder().

=cut

sub parse {
    my ( $self ) = @_;
    croak 'parse not implemented';
}

=method is()

Return the type of token we are.

=cut

sub is { # uncoverable subroutine
    # a base Token cannot be instantiated, and all subclasses should implement this method.
    my ( $self ) = @_; # uncoverable statement
    croak 'is not implemented'; # uncoverable statement
}

1;;

