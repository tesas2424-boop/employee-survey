<?php
require_once __DIR__.'/../includes/auth.php'; require_once __DIR__.'/../includes/csrf.php'; require_once __DIR__.'/../includes/audit.php';
$d=json_input(); require_csrf($d['csrf_token']??null); $action=$d['action']??'';
if($action==='login'){
 $s=db()->prepare('SELECT * FROM users WHERE email=? AND active=1 LIMIT 1'); $s->execute([trim($d['email']??'')]); $u=$s->fetch();
 if(!$u || !password_verify($d['password']??'',$u['password_hash'])) json_response(['ok'=>false,'message'=>'Invalid email or password'],422);
 login_user($u); audit('login','user',(int)$u['id']); json_response(['ok'=>true,'user'=>current_user()]);
}
if($action==='logout'){ require_api_login(); audit('logout','user',(int)current_user()['id']); logout_user(); json_response(['ok'=>true]); }
json_response(['ok'=>false,'message'=>'Unsupported action'],400);
