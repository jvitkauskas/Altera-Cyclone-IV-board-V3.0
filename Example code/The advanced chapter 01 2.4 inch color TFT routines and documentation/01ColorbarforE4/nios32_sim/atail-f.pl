#Copyright (C)2001-2010 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.

































@prog = split (/\/|\\/,$0) ; $pname = $prog[$#prog] ;

select(STDIN);  $| = 1;         # make stdin  unbufferred
select(STDOUT); $| = 1;         # make stdout unbufferred

$SIG{'INT'} = 'quit';		# run &quit on ^C

&usage if @ARGV < 1;		# die without 1 (file) arg


$file = $ARGV[0];
$old_size = -1;
$size = 0;
$some_bytes = 0;
$char = 0;


($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,
     $size,$atime,$mtime,$ctime,$blksize,$blocks)
        = stat($file);

if (($size !=0) && ($old_size == -1)) {


    $formatted_time = &get_formatted_time();
    syswrite (STDOUT,
"\n$pname: $file contains stale data at time $formatted_time.\n".
"------------------------------------------------------------------------\n");
}





die if (&args_test($file) && sleep 5);








while (1) {

    if (($size == 0) && ($size != $old_size)) {
        $formatted_time = &get_formatted_time();
        syswrite (STDOUT,
"\n$pname: $file size is zero at time $formatted_time.\n".
"------------------------------------------------------------------------\n");
        $old_size = $size;
    }


    ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,
     $size,$atime,$mtime,$ctime,$blksize,$blocks)
        = stat($file);



    if ($size > $old_size) {
        sysopen (LOG, $file, O_RDONLY) or &ktb(); # ktb == KickTheBucket
        sysseek (LOG, $old_size, 0);
        sysread (LOG, $some_bytes, $size - $old_size);
        close(LOG);
        if ($some_bytes =~ /([\n\r]*)([01]{8})([\n\r]{1,2})/) {
            $pre_crlf = $1;
            $pre_char = $2;
            $postcrlf = $3;
            $old_size += length($pre_crlf)+length($pre_char)+length($postcrlf);
            @zero_ones = split (//,$pre_char);
            for ($i = 0 ; $i <= $#zero_ones ; $i++) { # $#zero_ones should be 8
                if ($zero_ones[$i] =~ /1/) {
                    $char += 2**(7-$i);
                }
            }
            syswrite (STDOUT, (pack "c",$char));
            $char = 0;
        }
     }

    select(undef, undef, undef, 0.1);

} # end main loop [while TRUE]




sub usage {
    die "usage: $pname logfile\n";
} # usage

sub quit {			# interrupt handler for exit
    local ($sig) = @_;
    print STDERR "Caught SIG$sig; exiting...\n";
    close (LOG);
    sleep 1;
    exit;
} # quit

sub ktb {			# kick the bucket if file disappears
    local ($file) = @_;
    print STDERR "$pname: $file is gone!; exiting...\n";
    sleep 1;
    exit 1;
} # quit

sub args_test {			# return 0 for success; return 1 for fail
    local ($file) = @_;
    local $code = " ";
    local $die  = 0;



    if (defined (open (LOG, $file))) { 
	close(LOG);		# success
    } else {
	$code = "$!\n";		# remember fail reason
    }

    if ($code ne " ") {
        print STDERR "$pname: Cannot open '$file': $code";
        $die = 1;		# remember any failure
    }

    return $die;		# return any failure status.

} # args_test

sub get_formatted_time {        # create a timestring without using packages
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
    return (sprintf ("%.2d:%.2d:%.2d %.2d/%.2d/%.4d", $hour,$min,$sec,($mon + 1),$mday,($year + 1900)));
} # get_formatted_time
