# --
# Kernel/Output/HTML/HeaderMetaTicketSearch.pm
# Copyright (C) 2001-2010 OTRS AG, http://otrs.org/
# --
# $Id: HeaderMetaTicketSearch.pm,v 1.7 2010-07-07 10:04:14 mg Exp $
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::HeaderMetaTicketSearch;

use strict;
use warnings;

use vars qw($VERSION);
$VERSION = qw($Revision: 1.7 $) [1];

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # get needed objects
    for (qw(ConfigObject LogObject LayoutObject TimeObject)) {
        $Self->{$_} = $Param{$_} || die "Got no $_!";
    }

    return $Self;
}

sub Run {
    my ( $Self, %Param ) = @_;

    my $Session = '';
    if ( !$Self->{LayoutObject}->{SessionIDCookie} ) {
        $Session = ';' . $Self->{LayoutObject}->{SessionName} . '='
            . $Self->{LayoutObject}->{SessionID};
    }
    my $Title = $Self->{ConfigObject}->Get('ProductName');
    $Title .= '(' . $Self->{ConfigObject}->Get('Ticket::Hook') . ')';
    $Self->{LayoutObject}->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => $Title,
            Href  => '$Env{"Baselink"}Action=' . $Param{Config}->{Action}
                . '&amp;Subaction=OpenSearchDescriptionTicketNumber' . $Session,
        },
    );

    my $Fulltext = $Self->{LayoutObject}->{LanguageObject}->Get('Fulltext');
    $Title = $Self->{ConfigObject}->Get('ProductName');
    $Title .= '(' . $Fulltext . ')';
    $Self->{LayoutObject}->Block(
        Name => 'MetaLink',
        Data => {
            Rel   => 'search',
            Type  => 'application/opensearchdescription+xml',
            Title => $Title,
            Href  => '$Env{"Baselink"}Action=' . $Param{Config}->{Action}
                . '&amp;Subaction=OpenSearchDescriptionFulltext' . $Session,
        },
    );
    return 1;
}

1;
