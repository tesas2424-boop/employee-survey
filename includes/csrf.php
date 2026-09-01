<?php
require_once __DIR__ . '/functions.php';
function csrf_token(): string { if(empty($_SESSION['_csrf'])) $_SESSION['_csrf']=bin2hex(random_bytes(32)); return $_SESSION['_csrf']; }
function csrf_field(): string { return '<input type="hidden" name="csrf_token" value="'.e(csrf_token()).'">'; }
function verify_csrf(?string $token): bool { return is_string($token) && hash_equals($_SESSION['_csrf']??'', $token); }
function require_csrf(?string $token): void { if(!verify_csrf($token)) json_response(['ok'=>false,'message'=>'Invalid CSRF token'],419); }
