// ==UserScript==
// @name           CPAN Vote
// @namespace      http://babyl.ca/cpanvote
// @include        http://search.cpan.org/dist/*
// @require        http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js
// ==/UserScript==

var cpanvote_url = "http://enkidu:3000";
var first_vote_grab = true;

gm_xhr_bridge();

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


function get_votes_old () {
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
function get_votes () {
    var dist = $('h1').text();

    $.getJSON(
        cpanvote_url + '/dist/' + dist + '/votes', 
        function(data) {
            var results = '+' + data["yea"] + ", 0 x " + data["meh"] + ", -" + data["nea"];
            $('#cpanvotes').html( results );

            if ( first_vote_grab ) {
                prepare_voting(dist,data);
            }

        } 
    );
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
            + '<input type="radio" name="vote" value="meh"> meh'
            + '<input type="radio" name="vote" value="nea"> nea'
            + '</form>'
        );

        if ( data["my_vote"] != undefined ) {
            $('#voting_station').find(
                ':radio[value=' + data["my_vote"] +']' 
            ).attr( 'checked', true );
        }

        $('#voting_station').find(':radio').click(function(){
            $.ajax({
                url: form_url + '/' + $('#voting_station').find(':radio:checked').val(),
                type: 'PUT',
                dataType: 'json',
                success: function() { get_votes(); }
            });
        });

        var instead_form_url = cpanvote_url + '/dist/' + dist + '/instead';
        $('#voting_station').append(
                '<form id="instead_form" action="' + instead_form_url +'">'
                + 'instead, use <input id="instead" name="instead" />'
                + '<input type="button" value="submit" id="instead_submit" />'
                + '</form>'
        );

        $('#instead_submit').click(function(){ submit_instead() } );
    }
} 

function submit_instead() {
    var form = $('#instead_form');

    var instead = form.find('#instead').val().replace( /::/g, '-' );

    if ( instead == "" ) {
        return;
    }

    var url = form.attr('action');

    $.ajax({
        url: form.attr('action') + '/' + instead,
        type: 'PUT',
        dataType: 'json',
        success: function() { 
            // ... 
        }
    });

}


// Wrapper function
function GM_XHR() {
    this.type = null;
    this.url = null;
    this.async = null;
    this.username = null;
    this.password = null;
    this.status = null;
    this.headers = {};
    this.readyState = null;
    
    this.open = function(type, url, async, username, password) {
        this.type = type ? type : null;
        this.url = url ? url : null;
        this.async = async ? async : null;
        this.username = username ? username : null;
        this.password = password ? password : null;
        this.readyState = 1;
    };
    
    this.setRequestHeader = function(name, value) {
        this.headers[name] = value;
    };
        
    this.abort = function() {
        this.readyState = 0;
    };
    
    this.getResponseHeader = function(name) {
        return this.headers[name];
    };
    
    this.send = function(data) {
        this.data = data;
        var that = this;
        GM_xmlhttpRequest({
            method: this.type,
            url: this.url,
            headers: this.headers,
            data: this.data,
            onload: function(rsp) {
                // Populate wrapper object with all data returned from GM_XMLHttpRequest
                for (k in rsp) {
                    that[k] = rsp[k];
                }
            },
            onerror: function(rsp) {
                for (k in rsp) {
                    that[k] = rsp[k];
                }
            },
            onreadystatechange: function(rsp) {
                for (k in rsp) {
                    that[k] = rsp[k];
                }
            }
        });
    };
};
function gm_xhr_bridge() {
// Author: Ryan Greenberg (ryan@ischool.berkeley.edu)
// Date: September 3, 2009
// Version: $Id: gm_jq_xhr.js 240 2009-11-03 17:38:40Z ryan $

// This allows jQuery to make cross-domain XHR by providing
// a wrapper for GM_xmlhttpRequest. The difference between
// XMLHttpRequest and GM_xmlhttpRequest is that the Greasemonkey
// version fires immediately when passed options, whereas the standard
// XHR does not run until .send() is called. In order to allow jQuery
// to use the Greasemonkey version, we create a wrapper object, GM_XHR,
// that stores any parameters jQuery passes it and then creates GM_xmlhttprequest
// when jQuery calls GM_XHR.send().

// Tell jQuery to use the GM_XHR object instead of the standard browser XHR
$.ajaxSetup({
    xhr: function(){return new GM_XHR;}
});
}
