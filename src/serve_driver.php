<?php
$vendor=$_GET['v'];
$device=$_GET['d'];
$drivers_path="/srv/tftpboot/samba/install/drivers";
$file="drivers.cab";
exec("lcab -n -r ${drivers_path}/${vendor}/${device}/ ".$file);

header('Content-Description: File Transfer');
header('Content-Disposition: attachment; filename='. basename($file));
header('Expires: 0');
header('Cache-Control: must-revalidate');
header('Pragma: public');
header('Content-Length: ' . filesize($file));
header('Content-Type: application/octet-stream');
readfile($file);

