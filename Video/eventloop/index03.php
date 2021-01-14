<html>
<head>
  <title>Eventloop Folien Erzeugen</title>

    <!-- example css -->
    <style type="text/css">
    		red {
    				color:red;
				}
        table {
            border: none;
            border-spacing: 5px;
            margin-left:auto; 
            margin-right:auto;
            width:80%; 
        }
        td.divider {
            border-right:3px solid red;
        }
        td.space {
            padding-top: 5px;
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

  <meta charset="UTF-8">

</head>
<body>
  <form enctype="multipart/form-data" action="index.php" method="POST">
     <table>
    <tr><td align='center' colspan="2"><h2>1. Schritt</h2></td></tr>
    <tr><td colspan="2">TextDatei vorbereiten und danach uploaden</td></tr>
            <tr><td align='left' colspan="2">
    <p>Erstelle eine txt Datei - Textteile werden mit folgenden Zeilen von einander getrennt: "//"</p>
    </td></tr>
    <tr><td align='left' colspan="2">
    <p>Zum Beispiel:<BR / >
    Titel<BR />
    Datum:<BR />
    Uhrzeit:<BR />
    Ort:<BR />
    Kontakt:<BR />
    //<BR />
    Noch ein Titel<BR />
    Datum:<BR />
    Uhrzeit:<BR />
    Ort:<BR />
    Kontakt:<BR />
    //<BR />
    </td></tr>
    <tr><td align='left' colspan="2">
    <p>Upload die Datei mit dem Namen: eventloop.txt</p>
     </td></tr>
    <tr><td align='left' width="100px">
    <input type="file" name="uploaded_file"></input>
     </td>
    <td align='left'>
    <input type="submit" value="Datei Upload"></input>
        </td></tr>

      </table>

  </form>
</body>
</html>
<?PHP
  if(!empty($_FILES['uploaded_file']))
  {
    $path = "";
    $path = $path . basename( $_FILES['uploaded_file']['name']);

    if(move_uploaded_file($_FILES['uploaded_file']['tmp_name'], $path)) {
      echo "<span>Die Datei ".  basename( $_FILES['uploaded_file']['name']). 
      " wurde erfolgreich geladen.</span>";
        } else{
            echo "Leider ist etwas schiefgegangen, versuch es nochmal!";
        }
      }

?>

    <table>
    <tr><td align='center' colspan="2"><h2>2. Schritt</h2></td></tr>
    <tr><td align='center' colspan="2"><h3>Folien Erzeugen</h3></td></tr>
    <tr><td align='left' colspan="2">
    <tr><td align='left' colspan="2">
    <form action="index_alpha.php" method="get">
    <input type="submit" value="Folien Erstellen">
    </form>
    </td></tr>
    </table>

    <table>
    <tr><td align='center' colspan="2"><h2>3. Schritt</h2></td></tr>
    <tr><td align='center' colspan="2"><h3>Zip Downloaden - Optional</h3></td></tr>
    <tr><td align='left' colspan="2">
    <tr><td align='left' colspan="2">
    <form action="zip03.php" method="get">
    <input type="submit" value="Zip Datei">
    </form>
    </td></tr>
    </table>


    <table>
    <tr  align='center'><td><h2>4. Schritt</h2></td>
    <td><h2>5. Schritt</h2></td></tr>
    <tr  align='center'><td><h3>Powerpoint Erzeugen</h3></td>
    <td><h3>Powerpoint downloaden</h3></td></tr>
    <tr align='center'><td>
    <form action="powerpoint.php" method="get">
    <input type="submit" value="Powerpoint erzeugen">
    </form>
    </td>
    <td><form action="powerpoint_download.php" method="get">
    <input type="submit" value="Powerpoint">
    </form>
		</td>
    </tr>
    </table>
