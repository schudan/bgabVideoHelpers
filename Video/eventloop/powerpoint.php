<?php
    //setting the image header in order to proper display the image
    header( "refresh:2;url=./index.php" );

// if you want the page to be able to do something with the result:
$output = `python3 pptximage02.py 2>&1`;
#echo $output;
?>