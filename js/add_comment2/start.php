<?php
	require_once @$_root_dir . 'includes/plugin.php';

eval("class " . basename(__DIR__) . " extends widget {}");

?>