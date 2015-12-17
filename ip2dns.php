<?php 
/*
* IP2DNS coded by G66k
* FREENODE ##SPOONFED
*/

?>
<html>
<head>
	<title>IP 2 DNS</title>
	<link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/css/bootstrap.min.css">
	<script type="text/javascript" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.6/js/bootstrap.min.js"></script>
</head>
<body>

<br />
  <div class="container">
     <center>
     	<h3>Enter List (domain/ips)</h3>

     	<form action="" name="form" method="POST">
<tr>
<textarea rows="10" cols="40" name="list">
</textarea><br/>
<input class="btn btn-primary btn-large" type="submit" name="submit" value="Start!" />
</tr>
</form>
<br/>
<p></p>
	<?php 
	      $result = array();
	      $out = '';
        if(isset($_POST['submit'])){
        	if(isset($_POST['list']) && !empty($_POST['list'])){
        		$list = $_POST['list'];
        		$ips = explode("\n",$list);
        		foreach ($ips as $ip) {
        			trim($ip);
        			$content = file_get_contents('https://www.robtex.com/q/x1?q=' . $ip . '&l=go');
        			if(preg_match_all('/>host\sname\s<b>(.+)<\/b>/',$content,$match)){
        				foreach ($match[1] as $value) {
                               array_push($result,$value);


                        }
        				
        			}
        		}
        	}
        }
         $clean = array_unique($result);
         foreach ($clean as $v) {
         	       $out .= $v."\n";
         
                  }
        echo'<h3>Found:('.count($clean).')</h3><textarea rows="10" cols="40" name="list">'.$out.'</textarea><br/>';


 
	 ?>
</center>
<br />
</div>

</body>
</html>

