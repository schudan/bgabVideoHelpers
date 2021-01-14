<?php

// FETCH CONTENTS FROM FILE
$lyrics = file_get_contents('Lieder_LiveText.txt');
$res = explode("//", $lyrics);
$i = 1;
#$DIR = date("Ymd");
$DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));
$oldmask = umask(0);
mkdir($DIR, 0777, true);
umask($oldmask);
foreach($res as $value){
    #print_r($res);
#    $text = $value.count($res);
    $text = $value;
    
    $text=wordwrap($text, 55, "\n", TRUE);
    
    //setting the image header in order to proper display the image
    #header('Content-Disposition: Attachment;filename=test.png'); 
    header("Content-Type: image/png");
    //try to create an image
    $im = @imagecreate(1920, 1080)
    
#    $im2 = imagecreatefrompng("test.png");
        or die("Cannot Initialize new GD image stream");
    //set the background color of the image
    $background_color = imagecolorallocatealpha($im, 0, 0, 0, 127);
    $white = imagecolorallocate($im, 255, 255, 255);
    $grey = imagecolorallocate($im, 128, 128, 128);
    $black = imagecolorallocate($im, 0, 0, 0);
    $lime = imagecolorallocate($im, 204, 255, 51);
    $yellow = imagecolorallocate($im, 255, 255, 51);
    //set the color for the text
    $text_color = $white;
    //adf the string to the image
    
    #Font to be used
    $font = "./fonts/ariblk.ttf";
    $font_size = 40;
    $angle = 0;
    
    $splittext = explode ( "\n" , $text );
    $lines = count($splittext);
    
    foreach ($splittext as $text) {
        $text_box = imagettfbbox($font_size,$angle,$font,$text);
        $text_width = abs(max($text_box[2], $text_box[4]));
        $text_height = abs(max($text_box[5], $text_box[7])-($font_size/3));
        $x = (imagesx($im) - $text_width)/2;
        $y = ((imagesy($im) + $text_height)/2)-($lines+4)*$text_height;
        $lines=$lines-1;
        // Add some shadow to the text
    #    imagettftext($im, $font_size, $angle, $x+3, $y+403, $grey, $font, $text);
        // text
        imagettftext($im, $font_size, $angle, $x, $y+400, $text_color, $font, $text);
    }
    if ($i < 10 ){
    imagepng($im, "./$DIR/0$i.png");
    chmod("./$DIR/0$i.png", 0777); 
    } else {
    imagepng($im, "./$DIR/$i.png");
    chmod("./$DIR/$i.png", 0777); 
    }
    imagepng($im);
    $i = $i+1;
    imagedestroy($im);
    }
?>