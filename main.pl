use strict;
use warnings;
use Data::Dumper;
use List::Util qw/shuffle/;

# STEP 0: The user is asked which file contains the data for the quizz session
#print "Which quizz file do you want to use?\n";
#my $filename = <>;
#chomp($filename);

#open (my $fh, '<:encoding(UTF-8)', $filename)
#or die "Could not open file '$filename' $!";

# STEP 1: The data from the file is extracted and put into a dictionnary

# STEP 2: A number X of questions are asked and immediately corrected

my %hash = ();

$hash{ 'key1' } = ['value1.1', 'value2.1'];
$hash{ 'key2' } = ['value1.2'];
$hash{ 'key3' } = ['value1.3', 'value2.3', 'value3.3'];

ask(\%hash);

# STEP 3: A total score is given and the session ends

#close $fh;

##########################################

sub ask {
# This subroutine will display a question and all the possible answers
# It will then ask the answer and compare it with the right answer
# It should receive an hash as an argument ex:
#$VAR1 = {
#  'key1' => [
#    'value1.1',
#    'value2.1'
#            ],
#  'key2' => [
#    'value1.2'
#            ],
#        };
	my $hash = shift;
# First I list all of the keys from my hash
	my @listOfQuestions = keys %$hash;
# I then pick a question
# The elements of an hash are not sorted so no randomness is needed.
	my $question = $listOfQuestions[0];
	my @answers = @{ $hash{ $question } };
# The elements of a list are sorted so I will need to add some randomness
# But first I store the right answer which is always the first one
	my $rightAnswer = $answers[0];
	@answers = shuffle(@answers);
	print "Question: $question\n";
	my $letter = 'A';
	for my $i (0 .. $#answers) {
		if ($answers[$i] eq $rightAnswer) {
			$rightAnswer = $letter;
		}
		$answers[$i] = $letter . ' ' . $answers[$i];
		print "$answers[$i]\n";
		$letter++;
	}
	print "Your Answer: ";
	my $userAnswer = <STDIN>;
	chomp $userAnswer;
	if ($userAnswer eq $rightAnswer) {
		print "True\n";
	} else {
		print "False\n"
	}
}
