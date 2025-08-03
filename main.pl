#!/usr/bin/env perl
use Mojolicious::Lite -signatures;
use Mojo::IOLoop;
use Data::Dumper;

my @countdowns;
use strict;
use warnings;

sub tick_a_second ( $loop, $obj ) {
	my $id = $loop->recurring(
		1 => sub($loop) {
			if ( $obj->{done}++ > $obj->{timeout} ) {

				# print "\tdone\n";
				return $loop->remove( $obj->{timerid} );
			}
			$loop->emit($obj);

			# print "\tupdate $obj\n";

			# return tick_a_second( $loop, $obj );
		}
	);
	$obj->{timerid} = $id;
}
post '/count/:timeout' => sub ($c) {
	my $obj = { timeout => $c->param("timeout"), done => 0, recved => 0 };
	tick_a_second( Mojo::IOLoop->singleton, $obj );

	# Mojo::IOLoop->singleton->on(
	# 	$obj,
	# 	sub($ass) {
	# 		Dumper $ass;
	# 	}
	# );
	push @countdowns, $obj;
	$c->render( text => $#countdowns );

};
get '/count/:id' => sub ($c) {
	my $obj = $countdowns[ $c->param("id") ];
	if ( $obj->{done} > $obj->{timeout} ) {
		return $c->render( text => "done" );
	}

	# printf "%d %d %d\n", $obj->@{qw(timeout done recved)};
	my $recv = sub {
		return $c->render( text => $obj->{recved}++ );
	};
	if ( $obj->{recved} < $obj->{done} ) {
		return $recv->();
	}
	my $id = Mojo::IOLoop->singleton->once( $obj => $recv );
	$c->on( finish => sub { Mojo::IOLoop->singleton->unsubscribe($id) } );

};

app->start;

