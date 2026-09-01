<?php
require_once __DIR__.'/../includes/functions.php'; require_once __DIR__.'/../includes/auth.php'; require_once __DIR__.'/../includes/csrf.php';
if($_SERVER['REQUEST_METHOD']==='GET'){ $rows=db()->query('SELECT id,name FROM departments WHERE active=1 ORDER BY name')->fetchAll(); json_response(['ok'=>true,'departments'=>$rows]); }
require_api_login(); $d=json_input(); require_csrf($d['csrf_token']??null); if(($d['action']??'')==='create'){ $name=trim($d['name']??''); if(!$name)json_response(['ok'=>false,'message'=>'Department name is required'],422); $s=db()->prepare('INSERT INTO departments(name) VALUES(?)'); $s->execute([$name]); json_response(['ok'=>true,'id'=>db()->lastInsertId()]); } json_response(['ok'=>false],400);
