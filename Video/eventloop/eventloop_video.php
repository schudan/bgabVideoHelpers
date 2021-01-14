<?php
    //setting the image header in order to proper display the image
    header( "refresh:2;url=./index.php" );

// if you want the page to be able to do something with the result:
$output = shell_exec('sh ./eventloop_slides.sh');
#echo $output;
?>