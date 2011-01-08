package cpanvote;

use 5.12.0;

use Dancer ':syntax';
use Dancer::Plugin::DBIC;
use cpanvote::Schema;


use Dancer::Plugin::Auth::Twitter;

my $schema = cpanvote::Schema->connect( 'dbi:SQLite:dbname=./database.db' );

our $VERSION = '0.1';

set serializer => 'JSON';

auth_twitter_init();

get '/sample' => sub {
    template 'sample';
};

get '/' => sub {
    return redirect( "/welcome" );

    return redirect auth_twitter_authenticate_url
      if not session('twitter_user');
    return "howdie " . session('twitter_user')->{screen_name};
};

get '/auth/twitter' => sub {
    if ( not session('twitter_user') ) {
        redirect auth_twitter_authenticate_url;
    }
    else {
        redirect '/auth/twitter/callback';
    }
};

get '/auth/authenticated' => sub {
    return { username => session('cpanvote_username') };
};

get '/auth/authenticate' => sub {
    return redirect auth_twitter_authenticate_url;
};

get '/welcome' => sub {

    my $username = session('cpanvote_username');

    unless ($username) {

        if ( my $tu = session('twitter_user') ) {
            my $auth = schema->resultset('Auth')->find_or_create(     
             {
                 'protocol' => 'twitter',
                    'credential' => $tu->{screen_name},
                } );

            $username = $tu->{screen_name};
            unless ( $auth->user_id ) {
                # create new user...
                if ( schema->resultset('Users')
                    ->find( { username => $username } ) ) {
                    $username .= '_0';
                    $username++
                      while schema->resultset('Users')
                          ->find( { username => $username } );
                }

                my $u = schema->resultset('Users')->create({ username => $username });
                $auth->user_id( $u->id );
                $auth->update;
            }

            session cpanvote_username => $username;
        }
        else {
            return "couldn't authenticate you, sorry!";
        }
    }

    return "hi $username!";
};

get '/dist/:dist/vote/:vote' => sub {

    return send_error( 'you must be logged in to vote' ) unless session(
        'cpanvote_username');

    return send_error( "vote must be 'yea', 'nea' or 'meh'" ) unless
        grep { $_ eq params->{vote} } qw/ yea nea meh /;

    my $user = schema->resultset('Users')->find({username =>
            session('cpanvote_username') });

    my $dist = schema->resultset('Distributions')->find_or_create({distname =>
            params->{dist}});

    my $vote = $user->find_or_create_related( 'votes', { dist_id => $dist->id } );

    my %vote_value = ( nea => -1, meh => 0, yea => 1 );

    $vote->vote( $vote_value{ params->{vote} } );

    $vote->update;

    return {
        result => 'success',
    }

};

get '/dist/:dist/votes' => sub {
    my $dist = schema->resultset('Distributions')->find_or_create({ distname => params->{dist} } );
    my $votes = $dist->votes;

    # TODO Group By instead of this...
    my ( $yea, $nea, $meh ) = (0,0,0);
    while ( my $v = $votes->next ) {
        if ( $v->vote == 1 ) {
            $yea++;
        }
        elsif ( $v->vote == -1 ) {
            $nea++;
        }
        else { $meh++ }
    }

    my %data = (
        yea => $yea,
        nea => $nea,
        meh => $meh,
        total => $yea + $meh + $nea,
    );

    if ( my $username = session('cpanvote_username') ) {
        my $user = schema->resultset('Users')->find({ username => $username });
        if ( my $v = $dist->votes->find({ user_id =>
                    $user->id    }) ) {
            $data{my_vote} = $v->vote == -1 ? 'nea' : $v->vote == 1 ? 'yea' :
            'meh';
        }
    }

    return \%data;

};

true;
