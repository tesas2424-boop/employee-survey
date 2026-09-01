<?php
require_once __DIR__ . '/auth.php';
function can(string $ability): bool {
    $role=current_user()['role']??'';
    $map=[
      'super_admin'=>['manage_surveys','view_dashboard','review_feedback','export_data','manage_departments'],
      'survey_admin'=>['manage_surveys','view_dashboard','export_data'],
      'reviewer'=>['view_dashboard','review_feedback','export_data'],
    ];
    return in_array($ability,$map[$role]??[],true);
}
function require_permission(string $ability): void { if(!can($ability)){ http_response_code(403); exit('Forbidden'); } }
