<html>
<head>

  <title>Folien Erzeugen</title>
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
<h3><b>Livetext Editor:</b></h3><br />
<form action="" method="post">
<textarea name="text" rows="24" cols="52"><?php echo htmlspecialchars($text) ; ?></textarea>
<br />
<input type="submit"  value="speichern"/>
<input type="reset" value="neu laden"/>
</form>


		<table>
    <tr><td align='center' colspan="2"><h3>Folien Erzeugen</h3></td></tr>
    <tr><td align='left' colspan="2">
    <tr><td align='left' colspan="2">
    <form action="index_unten.php" method="get">
    <input type="submit" value="Folien Erstellen">
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



</div>