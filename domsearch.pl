#!/usr/bin/env perl
use Mojolicious::Lite;

# This is just some basic configuration to deploy using hypnotoad
app->config(hypnotoad => {
  listen   => ['http://127.0.0.1:9999'],
  proxy    => 1,
  workers  => 2,
  user     => 'www-data',
  pid_file => '/var/run/macmini/macmini.pid'
});

# GET on the root server directory
get '/' => sub {
  my $self = shift;
  my $ws = $self->req->headers->accept;
  my $pageURL = 'http://store.apple.com/us/buy-mac/mac-mini';
  $self->ua->get($pageUrl => sub {
    my ($ua, $tx) = @_;
    my $returnText;
    my $foundStatus = 0;
    # Text or DOM items to search for
    my $searchItems = $tx->res->dom('li.description')->
                        grep(qr/Intel HD Graphics 4000/)->uniq->text;
    if ($searchItems->size != 1)
    {
      $returnText = "<a href='http://store.apple.com/us/buy-mac/mac-mini'>
        Looks like there's finally a new mac mini!</a>";
      $foundStatus = 1;
    }
    elsif ($searchItems->size == 1)
    {
      $returnText = "Nope. Same old mac mini.";
      $foundStatus = 2;
    }
    else
    {
      $returnText = "There was a problem reading store.apple.com";
    }
    $self->respond_to(
      # Completely optional - add restful json!
      json => {json => {newMacMini => ($foundStatus == 1)?
          "True" :
          ($foundStatus == 2)?
            "False" :
            "Error reading store.apple.com"}},
      html => sub {$self->render('index', returnText => $returnText)}
    );
  });
};

app->start;
__DATA__

@@ index.html.ep
% layout 'default';
% title 'Is There a New Mac Mini Yet?';
<div style="margin-top: 15%;">
  <h2 style="text-align:center;"><%== $returnText %></h2>
</div>

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body>
    <h1 style="text-align:center;margin-top:10%;">
      Is there a new Mac Mini yet?
    </h1>
    <%= content %>
  </body>
</html>
