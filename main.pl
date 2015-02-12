use strict;
use warnings;
use Data::Dumper;

#print "Which quizz file do you want to use?\n";
#my $filename = <>;
#chomp($filename);

#open (my $fh, '<:encoding(UTF-8)', $filename)
#or die "Could not open file '$filename' $!";

my %hash = ();

$hash{ 'key1' } = ['value1.1', 'value2.1'];
$hash{ 'key2' } = ['value1.2'];
$hash{ 'key3' } = ['value1.3', 'value2.3', 'value3.3'];

# I will store in an array all of the keys contained in my dictionnary
#my @listOfQuestions = keys %hash;
#my $question = $listOfQuestions[0]; #it's random anyway because of the hash


ask(\%hash);

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
	print "Question: $question\n";
	my $letter = 'A';
	for my $i (0 .. $#answers) {
		print "$letter $answers[$i]\n";
		$letter++;
	}
	print "Your Answer: ";
	my $userAnswer = <STDIN>;
	chomp $userAnswer;
} 

#close $fh;
