# -*- coding:utf-8 mode:cperl -*-
use strict;
use warnings;

use Test::Output;
use Test::More;

use lib qw(../lib ./lib);
use ChangeLog;

{ # test 01
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => ".",
	   });

	# dump: grep all without date
	stdout_unlike { $cl->dump(); } qr/2010\-01\-01/, "dump";
	stdout_like { $cl->dump(); } qr/Test01\-01:/, "dump";
	stdout_like { $cl->dump(); } qr/Hello World/, "dump";
	stdout_like { $cl->dump(); } qr/Test01\-02:/, "dump";
	stdout_like { $cl->dump(); } qr/Good evening world/, "dump";
	stdout_like { $cl->dump(); } qr/Good night world/, "dump";
	stdout_unlike { $cl->dump(); } qr/2009\-12\-31/, "dump";
	stdout_like { $cl->dump(); } qr/Test02\-01:/, "dump";

	# dump_with_date: grep all with date
	stdout_like { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date";
	stdout_like { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date";
	stdout_like { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date";
	stdout_like { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date";
	stdout_like { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date";
	stdout_like { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date";
	# order of date
	stdout_like { $cl->dump_with_date(); } qr/2010\-01\-01 .+2009\-12\-31/s, "dump_with_date";

	# dump_report: grep all by report style (ascending order), and calc time
	stdout_like { $cl->dump_report(); } qr/2010\-01\-01/, "dump_report";
	stdout_like { $cl->dump_report(); } qr/Test01\-01: test01 element 60m/, "dump_report";
	stdout_unlike { $cl->dump_report(); } qr/Hello World/, "dump_report";
	stdout_like { $cl->dump_report(); } qr/Test01\-02: test02 element 50m/, "dump_report";
	stdout_unlike { $cl->dump_report(); } qr/Good evening world/, "dump_report";
	stdout_unlike { $cl->dump_report(); } qr/Good night world/, "dump_report";
	stdout_like { $cl->dump_report(); } qr/2009\-12\-31/, "dump_report";
	stdout_like { $cl->dump_report(); } qr/Test02\-01: test03 element/, "dump_report";
	# order of date (ascending order)
	stdout_like { $cl->dump_report(); } qr/2009\-12\-31 .+2010\-01\-01/s, "dump_report";

	close($fh);
}

{ # test 02 grep_pattern: Test01
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => "Test01",
	   });

	# dump: grep all without date
	stdout_unlike { $cl->dump(); } qr/2010\-01\-01/, "dump: grep Test01";
	stdout_like { $cl->dump(); } qr/Test01\-01:/, "dump: grep Test01";
	stdout_like { $cl->dump(); } qr/Hello World/, "dump: grep Test01";
	stdout_like { $cl->dump(); } qr/Test01\-02:/, "dump: grep Test01";
	stdout_like { $cl->dump(); } qr/Good evening world/, "dump: grep Test01";
	stdout_like { $cl->dump(); } qr/Good night world/, "dump: grep Test01";
	stdout_unlike { $cl->dump(); } qr/2009\-12\-31/, "dump: grep Test01";
	stdout_unlike { $cl->dump(); } qr/Test02\-01:/, "dump: grep Test01";

	# dump_with_date: grep all with date
	stdout_like { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date: grep Test01";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date: grep Test01";
	stdout_like { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date: grep Test01";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date: grep Test01";
	stdout_like { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date: grep Test01";
	stdout_like { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date: grep Test01";
	stdout_unlike { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date: grep Test01";
	stdout_unlike { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date: grep Test01";

	# dump_report: grep all by report style (ascending order), and calc time
	stdout_like { $cl->dump_report(); } qr/2010\-01\-01/, "dump_report: grep Test01";
	stdout_like { $cl->dump_report(); } qr/Test01\-01: test01 element 60m/, "dump_report: grep Test01";
	stdout_unlike { $cl->dump_report(); } qr/Hello World/, "dump_report: grep Test01";
	stdout_like { $cl->dump_report(); } qr/Test01\-02: test02 element 50m/, "dump_report: grep Test01";
	stdout_unlike { $cl->dump_report(); } qr/Good evening world/, "dump_report: grep Test01";
	stdout_unlike { $cl->dump_report(); } qr/Good night world/, "dump_report: grep Test01";
	stdout_unlike { $cl->dump_report(); } qr/2009\-12\-31/, "dump_report: grep Test01";
	stdout_unlike { $cl->dump_report(); } qr/Test02\-01: test03 element/, "dump_report: grep Test01";

	close($fh);
}


{ # test 03 grep_pattern: world
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => "world",
	   });

	# dump: grep all without date
	stdout_unlike { $cl->dump(); } qr/2010\-01\-01/, "dump: grep world";
	stdout_unlike { $cl->dump(); } qr/Test01\-01:/, "dump: grep world";
	stdout_unlike { $cl->dump(); } qr/Hello World/, "dump: grep world";
	stdout_like { $cl->dump(); } qr/Test01\-02:/, "dump: grep world";
	stdout_like { $cl->dump(); } qr/Good evening world/, "dump: grep world";
	stdout_like { $cl->dump(); } qr/Good night world/, "dump: grep world";
	stdout_unlike { $cl->dump(); } qr/2009\-12\-31/, "dump: grep world";
	stdout_unlike { $cl->dump(); } qr/Test02\-01:/, "dump: grep world";

	# dump_with_date: grep all with date
	stdout_like { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date: grep world";
	stdout_unlike { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date: grep world";
	stdout_unlike { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date: grep world";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date: grep world";
	stdout_like { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date: grep world";
	stdout_like { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date: grep world";
	stdout_unlike { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date: grep world";
	stdout_unlike { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date: grep world";

	# dump_report: grep all by report style (ascending order), and calc time
	stdout_like { $cl->dump_report(); } qr/2010\-01\-01/, "dump_report: grep world";
	stdout_unlike { $cl->dump_report(); } qr/Test01\-01: test01 element 60m/, "dump_report: grep world";
	stdout_unlike { $cl->dump_report(); } qr/Hello World/, "dump_report: grep world";
	stdout_like { $cl->dump_report(); } qr/Test01\-02: test02 element 50m/, "dump_report: grep world";
	stdout_unlike { $cl->dump_report(); } qr/Good evening world/, "dump_report: grep world";
	stdout_unlike { $cl->dump_report(); } qr/Good night world/, "dump_report: grep world";
	stdout_unlike { $cl->dump_report(); } qr/2009\-12\-31/, "dump_report: grep world";
	stdout_unlike { $cl->dump_report(); } qr/Test02\-01: test03 element/, "dump_report: grep world";

	close($fh);
}


{ # test 04 grep_pattern: world with ignore_case
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => "world",
		ignore_case => 1,
	   });

	# dump: grep all without date
	stdout_unlike { $cl->dump(); } qr/2010\-01\-01/, "dump: grep world with ignore_case";
	stdout_like { $cl->dump(); } qr/Test01\-01:/, "dump: grep world with ignore_case";
	stdout_like { $cl->dump(); } qr/Hello World/, "dump: grep world with ignore_case";
	stdout_like { $cl->dump(); } qr/Test01\-02:/, "dump: grep world with ignore_case";
	stdout_like { $cl->dump(); } qr/Good evening world/, "dump: grep world with ignore_case";
	stdout_like { $cl->dump(); } qr/Good night world/, "dump: grep world with ignore_case";
	stdout_unlike { $cl->dump(); } qr/2009\-12\-31/, "dump: grep world with ignore_case";
	stdout_unlike { $cl->dump(); } qr/Test02\-01:/, "dump: grep world with ignore_case";

	# dump_with_date: grep all with date
	stdout_like { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date: grep world with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date: grep world with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date: grep world with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date: grep world with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date: grep world with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date: grep world with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date: grep world with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date: grep world with ignore_case";

	# dump_report: grep all by report style (ascending order), and calc time
	stdout_like { $cl->dump_report(); } qr/2010\-01\-01/, "dump_report: grep world with ignore_case";
	stdout_like { $cl->dump_report(); } qr/Test01\-01: test01 element 60m/, "dump_report: grep world with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Hello World/, "dump_report: grep world with ignore_case";
	stdout_like { $cl->dump_report(); } qr/Test01\-02: test02 element 50m/, "dump_report: grep world with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Good evening world/, "dump_report: grep world with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Good night world/, "dump_report: grep world with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/2009\-12\-31/, "dump_report: grep world with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Test02\-01: test03 element/, "dump_report: grep world with ignore_case";

	close($fh);
}

{ # test 05 grep: tag only
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => "world",
		ignore_case => 0,
		grep_tag_only => 1,
	   });

	# dump: grep all without date
	stdout_unlike { $cl->dump(); } qr/2010\-01\-01/, "dump: grep world tag_only";
	stdout_unlike { $cl->dump(); } qr/Test01\-01:/, "dump: grep world tag_only";
	stdout_unlike { $cl->dump(); } qr/Hello World/, "dump: grep world tag_only";
	stdout_unlike { $cl->dump(); } qr/Test01\-02:/, "dump: grep world tag_only";
	stdout_unlike { $cl->dump(); } qr/Good evening world/, "dump: grep world tag_only";
	stdout_unlike { $cl->dump(); } qr/Good night world/, "dump: grep world tag_only";
	stdout_unlike { $cl->dump(); } qr/2009\-12\-31/, "dump: grep world tag_only";
	stdout_unlike { $cl->dump(); } qr/Test02\-01:/, "dump: grep world tag_only";

	# dump_with_date: grep all with date
	stdout_unlike { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date: grep world tag_only";
	stdout_unlike { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date: grep world tag_only";
	stdout_unlike { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date: grep world tag_only";
	stdout_unlike { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date: grep world tag_only";
	stdout_unlike { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date: grep world tag_only";
	stdout_unlike { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date: grep world tag_only";
	stdout_unlike { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date: grep world tag_only";
	stdout_unlike { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date: grep world tag_only";

	# dump_report: grep all by report style (ascending order), and calc time
	stdout_unlike { $cl->dump_report(); } qr/2010\-01\-01/, "dump_report: grep world tag_only";
	stdout_unlike { $cl->dump_report(); } qr/Test01\-01: test01 element 60m/, "dump_report: grep world tag_only";
	stdout_unlike { $cl->dump_report(); } qr/Hello World/, "dump_report: grep world tag_only";
	stdout_unlike { $cl->dump_report(); } qr/Test01\-02: test02 element 50m/, "dump_report: grep world tag_only";
	stdout_unlike { $cl->dump_report(); } qr/Good evening world/, "dump_report: grep world tag_only";
	stdout_unlike { $cl->dump_report(); } qr/Good night world/, "dump_report: grep world tag_only";
	stdout_unlike { $cl->dump_report(); } qr/2009\-12\-31/, "dump_report: grep world tag_only";
	stdout_unlike { $cl->dump_report(); } qr/Test02\-01: test03 element/, "dump_report: grep world tag_only";

	close($fh);
}

{ # test 06 grep: tag only with ignore case
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => "test01",
		ignore_case => 1,
		grep_tag_only => 1,
	   });

	# dump: grep all without date
	stdout_unlike { $cl->dump(); } qr/2010\-01\-01/, "dump: grep test01 with ignore_case";
	stdout_like { $cl->dump(); } qr/Test01\-01:/, "dump: grep test01 with ignore_case";
	stdout_like { $cl->dump(); } qr/Hello World/, "dump: grep test01 with ignore_case";
	stdout_like { $cl->dump(); } qr/Test01\-02:/, "dump: grep test01 with ignore_case";
	stdout_like { $cl->dump(); } qr/Good evening world/, "dump: grep test01 with ignore_case";
	stdout_like { $cl->dump(); } qr/Good night world/, "dump: grep test01 with ignore_case";
	stdout_unlike { $cl->dump(); } qr/2009\-12\-31/, "dump: grep test01 with ignore_case";
	stdout_unlike { $cl->dump(); } qr/Test02\-01:/, "dump: grep test01 with ignore_case";

	# dump_with_date: grep all with date
	stdout_like { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date: grep test01 with ignore_case";

	# dump_report: grep all by report style (ascending order), and calc time
	stdout_like { $cl->dump_report(); } qr/2010\-01\-01/, "dump_report: grep test01 with ignore_case";
	stdout_like { $cl->dump_report(); } qr/Test01\-01: test01 element 60m/, "dump_report: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Hello World/, "dump_report: grep test01 with ignore_case";
	stdout_like { $cl->dump_report(); } qr/Test01\-02: test02 element 50m/, "dump_report: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Good evening world/, "dump_report: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Good night world/, "dump_report: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/2009\-12\-31/, "dump_report: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_report(); } qr/Test02\-01: test03 element/, "dump_report: grep test01 with ignore_case";

	close($fh);
}

{ # test 07 grep: specify start date
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => ".",
		start_date => "20100101",
	   });

	# dump_with_date: grep all with date
	stdout_like { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date: grep test01 with ignore_case";
}

{ # test 08 grep: specify end date
	my $test_file = "sample/clmemo01.txt";

	my $fh; open($fh, "<", $test_file) or die "can not open file:$!";
	my $cl = new ChangeLog($fh, {
		grep_pattern => ".",
		end_date => "20091231",
	   });

	# dump_with_date: grep all with date
	stdout_unlike { $cl->dump_with_date(); } qr/2010\-01\-01/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Test01\-01:/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Hello World/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Test01\-02:/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Good evening world/, "dump_with_date: grep test01 with ignore_case";
	stdout_unlike { $cl->dump_with_date(); } qr/Good night world/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/2009\-12\-31/, "dump_with_date: grep test01 with ignore_case";
	stdout_like { $cl->dump_with_date(); } qr/Test02\-01:/, "dump_with_date: grep test01 with ignore_case";
}

done_testing();
