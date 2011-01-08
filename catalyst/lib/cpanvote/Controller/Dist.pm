package cpanvote::Controller::Dist;
use Moose;
use namespace::autoclean;

BEGIN {
    extends 'Catalyst::Controller::REST';
}

=head1 NAME

cpanvote::Controller::Dist - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub base : Chained('/') : PathPart('dist') : CaptureArgs(1) {
    my ( $self, $c, $distname ) = @_;

    $c->stash->{dist} =
      $c->model('cpanvoteDB::Distributions')
      ->find( { distname => $distname } )
      or $self->status_not_found( $c,
        message => "distribution $distname not found" )
      and $c->detach;
}

sub summary : Chained('base') : PathPart('summary') : ActionClass('REST') :
  Args(0) {
}

sub summary_GET {
    my ( $self, $c ) = @_;

    my $dist = $c->stash->{dist};

    my @points;    # 0 = neah, 1 = meh, 2 = yeah
    my @insteads;
    my @comments;

    for my $vote ( $dist->votes ) {
        $points[ $vote->vote + 1 ]++;
        push @insteads, $vote->instead_id;
        push @comments, $vote->comment;
    }

    my %data;
    $data{vote}{neah} = $points[0];
    $data{vote}{meh}  = $points[1];
    $data{vote}{yeah} = $points[2];
    $data{instead} =
      [ map { $_->distname }
          $c->model('cpanvoteDB::Distributions')
          ->search( { id => [ grep { defined } @insteads ] } ) ];
    $data{comments} = [ grep { defined } @comments ];

    $self->status_ok( $c, entity => \%data );
}

sub detailed : Chained('base') : PathPart('detailed') : ActionClass('REST') :
  Args(0) {
}

sub detailed_GET {
    my ( $self, $c ) = @_;

    my $dist = $c->stash->{dist};

    my @data;
    for my $vote ( $dist->votes ) {
        my %v;
        $v{who} = $vote->user->username;
        my $points = $vote->vote;
        $points = '+1' if $points == 1;
        $v{vote}    = $points;
        $v{comment} = $vote->comment if $vote->comment;
        $v{instead} = $vote->instead->distname if $vote->instead_id;
        push @data, \%v;
    }

    $self->status_ok( $c, entity => \@data );
}

sub vote : Chained('base') : PathPart(vote) : ActionClass('REST') : Args(0) {
}

sub vote_PUT {
    my ( $self, $c ) = @_;

    $c->authenticate;

    my %data = %{ $c->req->data };

    my $instead = undef;
    if ( $data{instead} ) {
        $instead =
          $c->model('cpanvoteDB::Distributions')
          ->find( { distname => $data{instead} } )
          or $self->status_bad_request( $c,
            message => "distribution '$data{instead}' is not recognized" );
    }

    use Devel::Dwarn;

    Dwarn %data;

    my $user = $c->user;

    $user->update_or_create_related(
        'votes' => {
            dist_id    => $c->stash->{dist}->id,
            comment    => $data{comment},
            vote       => $data{vote},
            instead_id => $instead ? $instead->id : undef,
        } );

    $self->status_accepted( $c, entity => { status => 'accepted' } );

}

=head1 AUTHOR

Yanick Champoux,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

