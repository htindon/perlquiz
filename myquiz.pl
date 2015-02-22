use diagnostics;
use Data::Dumper;

use strict;
use warnings;
use List::Util qw/shuffle/;
use Term::ANSIColor;
use POSIX;

# This first part of the program assumes the directory containing the Quiz
# files is named "quizfiles". It will prompt the user with its contents minus
# the . and .. 
# The user then has to type the filename. All data from the file is put into
# an array.
print color 'bold blue';
print "This is the list of the files present at the moment in the quiz directory:\n";
opendir(D, "quizfiles") || die "Can't open the Quiz directory: $!\n";
my @list = grep { (!/^\./) && -f "quizfiles/$_" } readdir(D);
closedir(D);
foreach my $file (@list) {
    print "[$file] ";
}
print "\n";

print "Which quizz file do you want to use? ";
print color 'reset';
my $filename = <STDIN>;
my $key = "";
my %set = ();
my @values= ();
my $i = 0;
my $number_of_questions = -1;
my $score = 0;
chomp($filename);
open FILE, "quizfiles/$filename" || die "Can't open the Quiz file: $!\n";
my @lines = <FILE>;
close FILE;

# Here the questions are given a number (sorted just like in the file) they are
# put into an hash with the question as a key and array of answer(s) as value
my $order = 1;
while ($i < $#lines) {
    chomp($lines[$i]);
    if ($lines[$i] eq "**") {
	$number_of_questions++;
	if (@values) {
	    @{ $set{ $key } } = @values;
	    @values = ();
	}
	$i++;
	$key = $order . ". " . $lines[$i];
	$order++;
	chomp($key);
    } else {
	push(@values, $lines[$i]);
    }
    $i++;
}

# The user now has to decide how many questions they want to answer to given
# the number of questions available in the file
print color 'bold blue';
print "There are $number_of_questions questions in this file.\n";
print "How many questions do you want to do in this session? ";
print color 'reset';
my $n = <STDIN>;
chomp($n);
my $j = $n; # I need the number of questions asked for later reference

# The program will now ask the user a number $j of questions from the file
# quizfiles/$filename that has been transformed into an hash with numbered
# questions as keys and arrays of answer(s) as values.
# nb: In the array of answers the first answer is always the right one
while ($j > 0) {
    my @list_of_questions = keys %set;
    my $question = $list_of_questions[ rand( $number_of_questions ) ];
    my @answers = @{ $set{ $question } };

    my $right_answer = $answers[0];
    @answers = shuffle(@answers);

# The question is printed while the right answer has already been stored above
# The type of answer expected may be an exact answer (the user has to type
# the answer, not pick one). This is the case assumed in the first part of 
# the if statement. If it's a classic MCQ, it falls in the else part.
    print colored("\n$question\n", 'bold yellow');
    if ($right_answer =~ /@@/) {
	$right_answer = substr($right_answer, 2);
	my $user_answer = <STDIN>;
	chomp $user_answer;
	if ($user_answer eq $right_answer) {
	    print colored("True\n", 'bold green');
	    $score++;
	} else {
	    print color 'bold red';
	    print "False\n";
	    print "The answer was: $right_answer\n";
	    print color 'reset';
	}
    } else {
	my $letter = 'A';
	for my $i (0 .. $#answers) {
	    if ($answers[$i] eq $right_answer) {
		$right_answer = $letter;
	    }
	    $answers[$i] = $letter . ' ' . $answers[$i];
	    print colored("$answers[$i]\n", 'bold yellow');
	    $letter++;
	}

# Here the program expect an answer from the user, either exact or a letter
# corresponding to a choice. Either way it will be compared to what's stored
# in $right_answer.
# If the answer is right the user is told so and the $score variable is
# incremented by one. Else the user is told so and the right answer is given.
	print "Your Answer: ";
	my $user_answer = <STDIN>;
	chomp $user_answer;
	if ($user_answer eq $right_answer) {
	    print colored ("True\n", 'bold green');
	    $score++;
	} else {
	    print color 'bold red';
	    print "False\n";
	    print "The answer was: $right_answer\n";
	    print color 'reset';
	}
    }
    $j--;
}
# A simple score is given
my $percentage = ceil($score * 100 / $n);
print color 'bold blue';
print "\nYour Score was: $score / $n ($percentage %) \n";
print color 'reset';
