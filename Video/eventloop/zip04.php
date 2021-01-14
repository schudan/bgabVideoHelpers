<?php
$DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));
$dir = "./$DIR/";
$zip = new ZipArchive();
$res = $zip->open(trim($dir, "/") . '.zip', ZipArchive::CREATE | ZipArchive::OVERWRITE);
if ($res === TRUE) {
    foreach (glob($dir . '*') as $file) {
        $zip->addFile($file, basename($file));
    }
    $zip->close();
} else {
    echo 'Failed to create to zip. Error: ' . $res;
}
?>