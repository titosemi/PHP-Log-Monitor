<?php 

$php_version = phpversion();

if ($php_version >= 5.3)
{
	session_register('foo');
}

?>