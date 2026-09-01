<?php
function validate_required(array $data, array $fields): array { $errors=[]; foreach($fields as $f){ if(!isset($data[$f]) || trim((string)$data[$f])==='') $errors[$f]='This field is required.'; } return $errors; }
function valid_question_type(string $type): bool { return in_array($type,['single','multiple','dropdown','rating','yesno','short_text','long_text'],true); }
