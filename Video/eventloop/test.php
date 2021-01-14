<?php
    //Text To Add
    $text = "WTMatter.com Tutorial";
    
    $i = 0;

    
    //Background Image - The Image To Write Text On
    $image = imagecreatefrompng('bg.png');
    
    //Color of Text
    $textColor = imagecolorallocate($image, 255, 255, 255);
    
    //Full Font-File Path
    $fontPath = './fonts/ariblk.ttf';
    
    //Function That Write Text On Image
    imagettftext($image, 60, 0, 225, 425, $textColor, $fontPath, $text);
    imagepng($image, './20200524/image_01.png');

  
    //Set Browser Content Type
    header('Content-type: image/png');
 
    //Send Image To Browser
    imagepng($image);
    
    //Clear Image From Memory
    imagedestroy($image);
    
?>