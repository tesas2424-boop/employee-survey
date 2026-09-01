<?php
require_once __DIR__ . '/functions.php';
function current_user(): ?array { return $_SESSION['user'] ?? null; }
function logged_in(): bool { return current_user() !== null; }
function require_login(): void { if (!logged_in()) redirect('login.php'); }
function require_api_login(): void { if (!logged_in()) json_response(['ok'=>false,'message'=>'Authentication required'],401); }
function login_user(array $user): void { session_regenerate_id(true); $_SESSION['user']=['id'=>$user['id'],'name'=>$user['name'],'email'=>$user['email'],'role'=>$user['role']]; }
function logout_user(): void { $_SESSION=[]; if (ini_get('session.use_cookies')) { $p=session_get_cookie_params(); setcookie(session_name(),'',time()-42000,$p['path'],$p['domain'],$p['secure'],$p['httponly']); } session_destroy(); }
