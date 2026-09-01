<?php
require_once __DIR__.'/../includes/permissions.php'; require_once __DIR__.'/../includes/csrf.php'; require_once __DIR__.'/../includes/validation.php';
require_api_login(); require_permission('manage_surveys');
if($_SERVER['REQUEST_METHOD']==='GET' && isset($_GET['survey_id'])){ $s=db()->prepare('SELECT * FROM survey_questions WHERE survey_id=? ORDER BY sort_order,id');$s->execute([(int)$_GET['survey_id']]);$rows=$s->fetchAll();foreach($rows as &$r){$o=db()->prepare('SELECT * FROM question_options WHERE question_id=? ORDER BY sort_order,id');$o->execute([$r['id']]);$r['options']=$o->fetchAll();}unset($r);json_response(['ok'=>true,'questions'=>$rows]); }
json_response(['ok'=>false,'message'=>'Use the survey builder to manage questions.'],400);
