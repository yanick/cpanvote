package cpanvote;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    ConfigLoader
    Static::Simple
    Authentication
    Cache
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in cpanvote.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'cpanvote',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    authentication => {
        default_realm => 'http',
        realms => { 
            http => { 
                credential => { 
                    class => 'HTTP',
                    type  => 'any', # or 'digest' or 'basic'
                    password_type  => 'clear',
                    password_field => 'password'
                },
                store => {
                    class => 'DBIx::Class',
                    user_model => 'cpanvoteDB::Users',
                },
            },
            twitter => {
                credential => { 
                    class => 'Twitter',
                },
                consumer_key    => 'Bfco4J8hvOIWcd0NmpRog',
                consumer_secret => 'p9tcMQkTnZ3fJYrbVR4PUK6CQkGbEGIdPS9strK2o',
                callback_url    => 'http://localhost/auth/twitter/callback',
            },
            twitter_cli => {
                credential => { 
                    class => 'Twitter',
                },
                consumer_key    => 'zyhUrjCgTgs06ox1BJ7HGg',
                consumer_secret => 'osuYUQacxYcEpPA0edeb0h7tJs5ENzJedEZJi0RXbw',
                callback_url    => 'http://localhost/auth/twitter/callback',
            }
        },
    }
);

__PACKAGE__->config->{'Plugin::Cache'}{backend} = {
    class   => "Cache::Memory",
};


# Start the application
__PACKAGE__->setup();


=head1 NAME

cpanvote - Catalyst based application

=head1 SYNOPSIS

    script/cpanvote_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<cpanvote::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Yanick Champoux,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;