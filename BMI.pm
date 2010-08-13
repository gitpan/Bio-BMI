package Bio::BMI;

require 5.005_62;
use strict;
use warnings;

use vars qw( $VERSION );
$VERSION = '1.0';

sub import {
	*calc = \&mybmi;
}

# Modul written in Perl for calculating the "Body Mass Index" of an
# adult Person (above 18 years old) and interpreting the result using the
# international classification of WHO. This class considers amputation of
# body parts in its calculation also.

sub mybmi {
	my($size) = shift; # $size in cm
	my($weight) = shift; # $weight in kg
	my($bodypart) = shift || -1;
	my $bmi = 0;
	my $factor = 0;
	$size /= 100;

	#bodypart / Körperteil / Korrekturwert
	if($bodypart == 5){#5 thigh / Oberschenkel / 0,116
		$factor = 0.116 + 0.053 + 0.018;
	}elsif($bodypart == 4){#4 lower leg / Unterschenkel / 0,053
		$factor = 0.053 + 0.018;
	}elsif($bodypart == 3){#3 foot / Fuß / 0,018
		$factor = 0.018;
	}elsif($bodypart == 2){#2 upper arm / Oberarm / 0,035
		$factor = 0.035 + 0.023 + 0.008;
	}elsif($bodypart == 1){#1 forearm / Unterarm / 0,023
		$factor = 0.035 + 0.023 + 0.008;
	}elsif($bodypart eq "0"){#0 hand / Hand / 0,008
		$factor = 0.008;
	}else{
		$factor = 0;
	}

	my $w = $weight;
	if($weight != 0 && $size != 0){
		if($factor > 0){
			$w = $weight * (1 / (1 - $factor));
		}
		# formula: weight(kg) / size(m)^2
		$bmi = sprintf("%.2f",($w / ($size**2)));
	}

	# Using international classification of adult BMI precised by WHO
	# visible at http://apps.who.int/bmi/index.jsp?introPage=intro_3.html
	my @msg = (
		"Severe thinness",
		"Moderate thinness",
		"Mild thinness",
		"Normal range",
		"Pre-obese",
		"Obese class I",
		"Obese class II",
		"Obese class III"
	);

	# underweight ( <18.5 )
	if($bmi < 16){
		return $msg[0];
	}
	if($bmi >= 16 && $bmi < 17){
		return $msg[1];
	}
	if($bmi >= 17 && $bmi < 18.5){
		return $msg[2];
	}
	# normal range ( 18.5 - 24.99 )
	if($bmi >= 18.5 && $bmi < 25){
		return $msg[3];
	}
	# overweight ( 25.0 - 29.99 )
	if($bmi >= 25 && $bmi < 30){
		return $msg[4];
	}
	# Adipositas ( >30 )
	if($bmi >= 30 && $bmi < 35){
		return $msg[5];
	}
	if($bmi >= 35 && $bmi < 40){
		return $msg[6];
	}
	if($bmi >= 40){
		return $msg[7];
	}

	return $bmi;
}

1;
__END__

=head1 NAME

Bio::BMI - Body Mass Index calculate

=head1 SYNOPSIS

      use Bio::BMI;
      $alice_bmi = Bio::BMI::calc(168,57); # Alice = 168cm, 57kg
      $bob_bmi = Bio::BMI::calc(182,91,2);# Bob = 182cm, 91 kg, has lost his right complete arm after an accident

=head1 DESCRIPTION

Modul written in Perl for calculating the "Body Mass Index" of an
adult Person (above 18 years old) and interpreting the result using the
international classification of WHO. This class considers amputation of
body parts in its calculation also.

Using international classification of adult BMI precised by WHO
visible at http://apps.who.int/bmi/index.jsp?introPage=intro_3.html

=head1 EXPORT

NOTHING

=head1 AUTHOR

Stefan Gipper <stefanos@cpan.org>, http://www.coder-world.de/

=head1 SEE ALSO

perl(1)

=cut
