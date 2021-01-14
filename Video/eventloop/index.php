<html>
<head>

  <title>Eventloop Folien Erzeugen</title>
<style>
.content {
  max-width: 500px;
  margin: auto;
}
</style>

    <!-- example css -->
    <style type="text/css">
        table {
            border: none;
            border-spacing: 5px;
            margin-left:auto; 
            margin-right:auto;
            width:50%; 
        }
        td.divider {
            border:3px solid red;
        }
        td.space {
            padding-top: 5px;
            padding-left: 5px;
            padding-right: 5px;
            padding-bottom: 15px;
        }

       span {
            padding-left: 160px;
            padding-bottom: 15px;
        }

  </style>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>

  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
  <link rel="shortcut icon" href="favicon.ico" type="image/x-icon"/>
</head>
<body>

<div class="content">

<?php
	 if(date('D') == ('Sun')) { 
	      $DIR=date("Ymd",strtotime('today UTC',strtotime(date("Ymd"))));
	    } else {
	      $DIR=date("Ymd",strtotime('next sunday',strtotime(date("Ymd"))));
	    }
// configuration
$url = 'index.php';
$file = 'eventloop.txt';

// check if form has been submitted
if (isset($_POST['text']))
{
    // save the text contents
    file_put_contents($file, $_POST['text']);
    chmod($file, 0777);

    // redirect to form again
    header(sprintf('Location: %s', $url));
    printf('<a href="%s">Moved</a>.', htmlspecialchars($url));
    exit();
}

// read the textfile
$text = file_get_contents($file);
?>
<!-- HTML form -->
<h3><b>Event Loop Editor:</b></h3><br />
<form action="" method="post">
<textarea name="text" rows="18" cols="52"><?php echo htmlspecialchars($text) ; ?></textarea>
<br />
<input type="submit"  value="speichern"/>
<input type="reset" value="neu laden"/>
</form>

    <table>
    <tr><td align='center' colspan="2"><h3>Kalendar Events holen</h3></td></tr>
    <tr><td align='left' colspan="2">
    <tr><td align='left' colspan="2">
    <form action="https://bgab.de/xml/eventloop_AE.php" method="get">
    <input type="submit" value="Events holen">
    </form>
    </td></tr>
    </table>


		<table>
    <tr><td align='center' colspan="2"><h3>Folien Erzeugen</h3></td></tr>
    <tr><td align='left' colspan="2">
    <tr><td align='left' colspan="2">
    <form action="index_alpha.php" method="get">
    <input type="submit" value="Folien Erstellen">
    </form>
    </td></tr>
    </table>

    <table>
    <tr><td align='center' colspan="2"><h3>Eventloop mp4 Erzeugen</h3></td></tr>
    <tr><td align='left' colspan="2">
    <tr><td align='left' colspan="2">
    <form action="eventloop_video.php" method="get">
    <input type="submit" value="Eventloop mp4">
    </form>
    </td></tr>
    </table>

    <table>
    <tr><td align='center' colspan="2"><h3>Powerpoint Erzeugen</h3></td></tr>
    <tr><td align='left' colspan="2">
    <tr><td align='left' colspan="2">
    <form action="powerpoint.php" method="get">
    <input type="submit" value="Powerpoint">
    </form>
    </td></tr>
    </table>

<?php
# images produced
$files = scandir('./'.$DIR); 
 
$c1 = count($files);
$c2 = 0;
 
for($i=0; $i<$c1; $i++)
{
  if(strlen($files[$i]) > 3)
  {
    $extension = strtolower(substr($files[$i], -4));
    if(($extension == ".gif") OR ($extension == ".jpg") OR ($extension == ".png"))
    {
      echo "<a href='./$DIR/$files[$i]' target='_blank'><img src='$DIR/$files[$i]' width='480''></a>";
			echo '<br /><br />';
    }
  }
}

?>
</div>