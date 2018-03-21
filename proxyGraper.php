<?php
#!/usr/bin/php
#   Author: AntiGov   
#   ProxyGraper: Grap and check Proxy
#   @MA

$proxies = array();

for ($i=0; $i < 384; $i+=64) {
    preg_match_all('/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})<\/td><td>(\d{1,5})/', _curl("https://hidemy.name/en/proxy-list/?type=hs&start=".$i."#list"), $matches);
    array_push($proxies, array_map("map_Proxy", $matches[1] , $matches[2]));
}

foreach ($proxies as $proxy) {
    if(is_array($proxy)){
        foreach ($proxy as $value) {
             if(check($value)){
                $ip = preg_split("/:/", $value);
                echo $value." ". getCountry($ip[0]). " Status: OK\n";
             }else{
                echo $value . " => Status: Dead\n";

             }
        }
    }
}
function map_Proxy($ip, $port){
    return($ip.":".$port);
}



function _curl($url,$post="",$usecookie = false) {  
    $ch = curl_init();
    if($post) {
        curl_setopt($ch, CURLOPT_POST ,1);
        curl_setopt ($ch, CURLOPT_POSTFIELDS, $post);
    }
    curl_setopt($ch, CURLOPT_URL, $url); 
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/6.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.7) Gecko/20050414 Firefox/1.0.3"); 
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    if ($usecookie) { 
    curl_setopt($ch, CURLOPT_COOKIEJAR, $usecookie); 
    curl_setopt($ch, CURLOPT_COOKIEFILE, $usecookie);    
    } 
    curl_setopt($ch, CURLOPT_RETURNTRANSFER,1); 
    $result=curl_exec ($ch); 
    curl_close ($ch); 
    return $result; 
}

function check($proxy) {  
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://icanhazip.com/'); 
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, 1);
    curl_setopt($ch, CURLOPT_USERAGENT, "Mozilla/6.0 (Windows; U; Windows NT 5.1; en-US; rv:1.7.7) Gecko/20050414 Firefox/1.0.3"); 
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT ,5); 
    curl_setopt($ch, CURLOPT_TIMEOUT, 5);
    curl_setopt($ch, CURLOPT_PROXY, 'http://'.$proxy);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER,1); 
    $result=curl_exec ($ch); 
    curl_close ($ch); 
    if(preg_match('/(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})/', $result)){
        return 1;
    }
    return 0;
}
function getCountry($ip){
    $url = 'http://ip-api.com/json/'.$ip;
    $info = json_decode(_curl($url));
       if($info->status == "success"){
          return "Country: $info->country City: $info->city RegionName: $info->regionName";
       }
}

?>
