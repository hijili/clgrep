#!/usr/bin/perl
# -*- coding:utf-8 mode:cperl -*-
use strict;
use warnings;
use lib qw(./lib);

use Getopt::Long qw(:config posix_default no_ignore_case gnu_compat);
use ChangeLog;

my $DEBUG = 0;

sub usage {
	print "Usage: $0 [OPTIONS] PATTERN [FILE]\n";
	print " parse options\n";
	print "  -i, --ignore-case: ignore case\n";
	print "  -t, --tag-only   : grep target is tag only \n";
	print "  -s, --start-date : start date (YYYYMM[DD])\n";
	print "  -e, --end-date   : end   date (YYYYMM[DD])\n";
	print "\n";
	print " output options\n";
	print "  -w, --with-date   : output with date\n";
	print "  -r, --report      : output report style\n";
	print "  --total[ize],--csv: output totalized time summary for each tag\n";
	print "\n";
	print "  -h, --help       : print this usage\n";
	print "\n";
}

my ($ignore_case, $with_date, $tag_only, $report_style, $totalize_time, $print_help)
	= (0, 0, 0, 0, 0);
my ($start_date, $end_date) = ("19000000", "99999999");
GetOptions(
		   "i|ignore-case" => \$ignore_case,
		   "w|with-date"   => \$with_date,
		   "t|tag-only"    => \$tag_only, # target of grep is tag only
		   "s|start-date=s"  => \$start_date,
		   "e|end-date=s"    => \$end_date,

		   "r|report"          => \$report_style,
		   "totalize|total|csv"=> \$totalize_time,

		   "h|help"        => \$print_help,
		  );
# accept only "2014" or "201501" and so on...
if (8-length($start_date) > 0) { $start_date .= "0"x (8-length($start_date)); }
if (8-length($end_date) > 0)   { $end_date .= "9"x (8-length($end_date)); }

my $pattern = shift @ARGV;
my $file = shift @ARGV;

if ($print_help) { &usage; exit 0; }
if (!defined $pattern) { &usage; exit 1; }

if (defined $file && !-f $file) {
	die "$file doesn't exist\n";
}
my $fh;
if (!defined $file) {
	$fh = *STDIN;
} else {
	open($fh, "<", $file) or die "can not open $file:$!";
}

my $cl = new ChangeLog($fh, {
	grep_pattern  => $pattern,
	ignore_case   => $ignore_case,
	grep_tag_only => $tag_only,
	start_date    => $start_date,
	end_date      => $end_date,
});


if ($report_style) {
	$cl->dump_report;
} elsif ($totalize_time) {
	$cl->dump_totalize_time;
} elsif ($with_date) {
	$cl->dump_with_date;
} else {
	$cl->dump;
}

exit 0;
