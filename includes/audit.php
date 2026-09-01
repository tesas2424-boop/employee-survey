<?php
require_once __DIR__ . '/functions.php';
function audit(string $action, string $entity, ?int $entityId=null, array $meta=[]): void {
    try { $s=db()->prepare('INSERT INTO audit_logs(user_id, action, entity_type, entity_id, metadata, created_at) VALUES(?,?,?,?,?,NOW())'); $s->execute([current_user()['id']??null,$action,$entity,$entityId,json_encode($meta)]); } catch(Throwable $e) { }
}
