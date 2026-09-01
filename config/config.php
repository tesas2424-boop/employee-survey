<?php
if (session_status() === PHP_SESSION_NONE) session_start();
date_default_timezone_set('Africa/Addis_Ababa');
define('APP_NAME', 'PulsePoint');
define('BASE_URL', getenv('APP_BASE_URL') ?: '');
define('EXPORT_PATH', dirname(__DIR__) . '/storage/exports');
