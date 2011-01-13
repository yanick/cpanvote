// ==UserScript==
// @name           CPAN Vote
// @namespace      http://babyl.ca/cpanvote
// @include        http://search.cpan.org/dist/*
// @require        http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js
// ==/UserScript==

var cpanvote_url = "http://cpanvote.babyl.ca";
var first_vote_grab = true;

$( function(){ 
    var rating_div = $($.grep( $('tr'), function(n,i){ 
        return $(n).find('td').text().match( /Rating/ ) })[0]
    );

    rating_div.after( 
        "<tr><td class='label'>CPAN Votes</td>"
    + "<td class='cell' colspan='3'><div id='cpanvotes'></div>" 
    + "<div id='voting_station'></div>"
    + "</td></tr>"
    );

    get_votes();
});

function get_votes () {
    var dist = $('h1').text().replace( /-/, '::' );

    GM_xmlhttpRequest({
        method: "GET",
        url: cpanvote_url + '/dist/' + dist + '/votes', 
        onload: function(resp) {
            var data = JSON.parse(resp.responseText);
            var results = '+' + data["yea"] + ", 0 x " + data["meh"] + ", -" + data["nea"];
            $('#cpanvotes').html( results );

            if ( first_vote_grab ) {
                prepare_voting(dist,data);
            }

        }, 
    });
}

function prepare_voting (dist,data) {
    first_vote_grab = false;

    if ( !("my_vote" in data ) ) {
        $( '#voting_station' ).html(
                "authenticate yourself " 
                + "<a href='" + cpanvote_url + "/auth/twitter'>"
                + "via Twitter to vote</a>"
            );
    }
    else {
        var form_url = cpanvote_url + '/dist/' + dist + '/vote';
        $( '#voting_station' ).html(
            "<form action='" + form_url + "'>"
            + '<input type="radio" name="vote" value="yea"> yea'
            + '<input type="radio" name="vote" value="nea"> nea'
            + '<input type="radio" name="vote" value="meh"> meh'
            + '</form>'
        );

        if ( data["my_vote"] != undefined ) {
            $('#voting_station').find(
                ':radio[value=' + data["my_vote"] +']' 
            ).attr( 'checked', true );
        }

        $('#voting_station').find(':radio').click(function(){
            GM_xmlhttpRequest({
                url: form_url + '/' + $('#voting_station').find(':radio:checked').val(),
                method: 'GET',
                onload: function(resp) { get_votes(); }
            });
        })
    }
} 
