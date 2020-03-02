# -*- coding:utf-8 mode:cperl -*-
package ChangeLog;
use strict;
use warnings;
use ChangeLogElement;

sub new ($) {
	my $class = shift;
	my $self = {
		"cl" => {},    # date -> array of ChangeLogElement
		"line_feed_code" => undef,

		# parse options
		"fh"            => shift,
		"grep_pattern"  => "",
		"ignore_case"   => 0,
		"grep_tag_only" => 0,
		"start_date"    => "19000000", # YYYYMMDD
		"end_date"      => "99999999",
	};
	bless $self, $class;

	if (! fileno($self->{fh})) {
		die "file handle is not opened!";
	}

	my $opt_hash = shift;
	if (defined $opt_hash) {
		$self->set_opts($opt_hash);
	}

	$self->_parse;
	return $self;
}

sub set_opts($) {
	my $self = shift;
	my $opts = shift;
	if (ref($opts) ne "HASH") {
		die "Input hash ref! ex: set_opts({start_date => 20160101, end_date => 20160330})";
	}

	foreach my $key (keys %{$opts}) {
		if (! defined $self->{$key}) { die "unsupported option: $key"; }
		$self->{$key} = $opts->{$key};
	}
}

sub _parse() {
	my $self = shift;
	my $fh = $self->{fh};
	seek($fh, 0, 0);

	if (!defined $self->{grep_pattern} || $self->{grep_pattern} eq "") {
		die "pattern of grep is not specified";
	}

	sub _grep_elm($) {
		my $self = shift;
		my $elm = shift;
		my $grep_target;
		if ($self->{grep_tag_only}) {
			$grep_target = $elm->{tag};
		} else {
			$grep_target = $elm->{content};
		}
		if (($self->{ignore_case} && $grep_target =~ /$self->{grep_pattern}/i) ||
				(!$self->{ignore_case} && $grep_target =~ /$self->{grep_pattern}/) ) {
			return 1;
		}
		return 0;
	};

	sub _add_elm($$) {
		my $self = shift;
		my $elm  = shift;
		my $date = shift;

		if (defined $self->{cl}->{"$date"}) {
			push @{$self->{cl}->{"$date"}}, $elm;
		} else {
			$self->{cl}->{"$date"} = [$elm];
		}
	};

	my $date = "";
	my $elm  = undef;
	foreach my $line (<$fh>) {
		if (!defined $self->{line_feed_code}) {
			if ($line =~ /([\r\n]+)$/) { $self->{line_feed_code} = $1; }
		}

		if ($line =~ /^[\s\t]*(\d{4})\-(\d{2})\-(\d{2})/) { # date line
			if (defined $elm) {
				if ($self->_grep_elm($elm)) {
					$self->_add_elm($elm, $date);
				}
				$elm = undef;
			}
			# ignore line which is out of period
			my $yyyymmdd = $1.$2.$3;
			if ($yyyymmdd < $self->{start_date} || $yyyymmdd > $self->{end_date}) {
				$date = "";
				next;
			}
			$date = $line;
			next;
		}
		if ($date eq "") { next; }

		if ($line =~ /^[\s\t]*\*/) { # line start with "*"
			if (defined $elm) {
				if ($self->_grep_elm($elm)) {
					$self->_add_elm($elm, $date);
				}
				$elm = undef;
			}
			$elm = new ChangeLogElement($line);
			next;
		}

		if (defined $elm) {
			$elm->append_content($line);
		}
	}

	if (defined $elm) {
		if ($self->_grep_elm($elm)) {
			$self->_add_elm($elm, $date);
		}
	}
}

sub dump_report() {
	my $self = shift;
	foreach my $date (sort keys %{$self->{cl}}) {
		print $date;
		my @elms = @{$self->{cl}->{$date}};
		foreach my $e (@elms) {
			my $head = $e->dump_header;
		}
	}
}

sub dump_totalize_time() {
	my $self = shift;
	my $total_time = {};
	my $total = 0;
	foreach my $date (keys %{$self->{cl}}) {
		foreach my $e (@{$self->{cl}->{$date}}) {
			if (!defined $total_time->{$e->{tag}}) {
				$total_time->{$e->{tag}} = $e->{time};
			} else {
				$total_time->{$e->{tag}} += $e->{time};
			}
			$total += $e->{time};
		}
	}

	print "# tag,time(minute)\n";
	print "# TOTAL_TIME,".$total."\n";
	foreach my $tag (sort keys %{$total_time}) {
		#if ($total_time->{$tag} == 0) { next; }
		print $tag.",".$total_time->{$tag}."\n";
	}
}

sub dump() {
	my $self = shift;
	my $with_date = shift;
	foreach my $date (reverse sort keys %{$self->{cl}}) {
		if (defined $with_date) { print $date; }
		my @elms = @{$self->{cl}->{$date}};
		foreach my $e (@elms) {
			$e->dump;
		}
	}
}
sub dump_with_date() {
	my $self = shift;
	$self->dump(1);
}

1;
