# -*- coding:utf-8 mode:cperl -*-
package ChangeLogElement;
use strict;
use warnings;

### format
# {YYYY-MM-DD} [day] {Name Name} <{email-address}>
#   * {tag1}[,{tag2},{tag3},...]: {header} [time]
#      {content}...

sub new ($) {
	my $class = shift;
	my $self = {
		"tag"     => "",
		"header"  => "",
		"content" => "",
		"time"    => 0, # min
	};
	bless $self, $class;

	my $str = shift;
	if (!defined $str || $str eq "") {
		die "header is null!\n";
	}

	$self->_parse_tag($str);
	return $self;
}

sub _parse_tag ($) {
	my $self = shift;
	my $str  = shift;

	if ($str =~ /^[\s\t]*\*[\s\t]*([^:]+):.*/) {
		$self->{header}  = $str;
		$self->{tag}     = $1;
		$self->{content} = $str;
	} else {
		die "unexpected header!: $str";
	}

	$self->_parse_time($str);
}

sub append_content ($) {
	my $self = shift;
	my $str  = shift;

	$self->_parse_time($str);
	$self->{content} .= $str;
}

sub _parse_time ($) {
	my $self = shift;
	my $str  = shift;

	my ($num, $unit);
	if ($str =~ /[\s\t]+([\d\.]+)([hm]{1})[\s\t\n\r]*$/) {
		($num, $unit) = ($1, $2);
	} else {
		return;
	}

	if ($unit eq "h") {
		$self->{time} += $num * 60;
	} elsif ($unit eq "m") {
		$self->{time} += $num;
	}
}

sub dump {
	my $self = shift;

	#print "[INFO] tag:".$self->{tag}." time:".$self->{time}."\n";
	print $self->{content};
}

1;
