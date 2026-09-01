<?php
require_once dirname(__DIR__) . '/config/config.php';
require_once dirname(__DIR__) . '/config/database.php';
function e($value): string { return htmlspecialchars((string)$value, ENT_QUOTES, 'UTF-8'); }
function json_input(): array { $d=json_decode(file_get_contents('php://input'), true); return is_array($d)?$d:[]; }
function json_response($data, int $status=200): never { http_response_code($status); header('Content-Type: application/json; charset=utf-8'); echo json_encode($data, JSON_UNESCAPED_UNICODE|JSON_UNESCAPED_SLASHES); exit; }
function redirect(string $url): never { header('Location: '.$url); exit; }
function is_post(): bool { return ($_SERVER['REQUEST_METHOD'] ?? 'GET') === 'POST'; }
function now(): string { return date('Y-m-d H:i:s'); }
function uuid_token(int $bytes=24): string { return bin2hex(random_bytes($bytes)); }
function app_url(string $path=''): string { return rtrim(BASE_URL,'/').'/'.ltrim($path,'/'); }
function flash(string $key, ?string $value=null): ?string { if ($value!==null){$_SESSION['_flash'][$key]=$value;return null;} $v=$_SESSION['_flash'][$key]??null; unset($_SESSION['_flash'][$key]); return $v; }
function request_ip_hash(): string { return hash('sha256', ($_SERVER['REMOTE_ADDR'] ?? 'unknown').'|'.date('Y-m-d')); }
