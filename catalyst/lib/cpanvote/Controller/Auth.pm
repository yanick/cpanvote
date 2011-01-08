package cpanvote::Controller::Auth;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

cpanvote::Controller::Auth - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched cpanvote::Controller::Auth in Auth.');
}

sub twitter_cli_auth :Local('twitter_cli') {
    my ( $self, $c ) = @_;

    return $c->res->redirect(
        $c->get_auth_realm('twitter_cli')->credential->authenticate_twitter_url($c)
        );
}

sub twitter_auth :Local('twitter_cli') {
    my ( $self, $c ) = @_;

    return $c->res->redirect(
        $c->get_auth_realm('twitter')->credential->authenticate_twitter_url($c)
        );
}

=head1 AUTHOR

Yanick Champoux,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
