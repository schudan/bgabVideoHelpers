<?php
	 if(date('D') == ('Sun')) { 
	      $DIR=date("Ymd",strtotime('today UTC',strtotime(date("Ymd"))));
	    } else {
	      $DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));
	    }
#$DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));
$oldmask = umask(0);
if (!file_exists('$DIR')) {
    mkdir($DIR, 0777, true);
}

umask($oldmask);
// FETCH CONTENTS FROM FILE
$lyrics = file_get_contents('eventloop.txt');
$res = explode("//", $lyrics);
$i = 1;

foreach($res as $value){
    #print_r($res);
#    $text = $value.count($res);
    $text = $value;
    
    $text=wordwrap($text, 50, "\n", TRUE);
    
    //try to create an image
    $im2 = imagecreatefrompng('bg.png');
    $im = @imagecreate(1920, 1080)
    
#    $im2 = imagecreatefrompng("test.png");
        or die("Cannot Initialize new GD image stream");
    //set the background color of the image
#    $background_color = imagecolorallocate($im, 0x00, 0x00, 0x00);
		$background_color = imagecolorallocatealpha($im, 0, 0, 0, 127);
    $white = imagecolorallocate($im2, 255, 255, 255);
    $grey = imagecolorallocate($im2, 128, 128, 128);
    $black = imagecolorallocate($im2, 0, 0, 0);
    $lime = imagecolorallocate($im2, 204, 255, 51);
    $yellow = imagecolorallocate($im2, 255, 255, 51);
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
        $x = (imagesx($im2) - 1500);
        $y = ((imagesy($im2) + $text_height)/2)-($lines-2)*($text_height*2);
        $lines=$lines-1;
        // Add some shadow to the text
        imagettftext($im2, $font_size, $angle, $x+3, $y+303, $black, $font, $text);
        // text
        imagettftext($im2, $font_size, $angle, $x, $y+300, $text_color, $font, $text);
#		    imagettftext($im2, $font_size, 0, $x, $y+150, $textColor, $fontPath, $text);

    }
    if ($i < 10 ){
#    imagepng($im, "./$DIR/0$i.png");
#    chmod("./$DIR/0$i.png", 0777); 
    //Function That Write Text On Image
    imagepng($im2, "./$DIR/image_0$i.png");

    
#    $i = 0;

    
    //Background Image - The Image To Write Text On
    $image = imagecreatefrompng('bg.png');
    
    //Color of Text
    $textColor = imagecolorallocate($image, 255, 255, 255);
    
    //Full Font-File Path
    $fontPath = './fonts/ariblk.ttf';
    
  
   } else {
    imagepng($im, "./$DIR/$i.png");
    chmod("./$DIR/$i.png", 0777); 
    }
    //setting the image header in order to proper display the image
    header( "refresh:4;url=./index.php" );
    header("Content-Type: image/png");
    imagepng($im2);
    $i = $i+1;
    imagedestroy($im2);
    }
?>

