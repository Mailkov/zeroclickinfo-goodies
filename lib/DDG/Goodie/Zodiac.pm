package DDG::Goodie::Zodiac;
#ABSTRACT: Find the Zodiac Sign by feeding Date as Input

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use strict;
use warnings;

use DateTime::Event::Zodiac qw(zodiac_date_name);

zci is_cached => 0;
zci answer_type => "zodiac";

triggers startend => "zodiac","zodiac sign","starsign","star sign";

my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

my @colors = qw(bg-clr--blue-light bg-clr--green bg-clr--red bg-clr--grey);

sub element_sign {
        my @sign = @_;
        my $versign = lc($sign[0]);
        # element Water
        return 0 if ($versign =~ m/(cancer|scorpius|pisces)/);
        # element Water
        return 1 if ($versign =~ m/(taurus|virgo|capricornus)/);
        # element Water
        return 2 if ($versign =~ m/(aries|sagittarius|leo)/);
        # element Water
        return 3 if ($versign =~ m/(libra|gemini|aquarius)/);
        return 0;
}

handle remainder => sub {
    my $datestring = $_;    # The remainder should just be the string for their date.

    # Parse the Given Date String
    my $zodiacdate = parse_datestring_to_date($datestring);

    # Return Nothing if the User Provided Date is Invalid
    return unless $zodiacdate;
    
    #Star Sign
    my $zodiacsign = ucfirst(zodiac_date_name($zodiacdate));

    # Return the Star Sign
    my $result="Zodiac for " . date_output_string($zodiacdate) . ": " . $zodiacsign;

    # Input String
    my $input = date_output_string($zodiacdate);
    
    my $index = element_sign($zodiacsign);
    
    # Background Color Icon
    my $bgcolor = $colors[$index];

    return $result, structured_answer => {
            id => "zodiac",
            name => "Answer",
            data => {
                image => "/share/goodie/zodiac/". $goodieVersion . "/" . lc($zodiacsign) . ".png",
                title => $zodiacsign,
                subtitle => $input
            },
            templates => {
                group => "icon",
                elClass => {
                    iconImage => $bgcolor . " circle"
                },
                variants => {
                     iconImage => 'large'
                }
            }
        };
};

1;
