VERIFICATION SQL (Run after REVOKE to confirm)

```sql
-- ============================================================
-- Verification — Confirm REVOKE is enforced
-- Run these as the authenticated/anon role (not service_role)
-- ============================================================

-- Test 1: UPDATE content should FAIL
-- Expected: ERROR: permission denied for table knowledge_nodes
UPDATE knowledge_nodes SET content = 'HACKED CONTENT' WHERE id = 'N-M02';

-- Test 2: DELETE should FAIL
-- Expected: ERROR: permission denied for table knowledge_nodes
DELETE FROM knowledge_nodes WHERE id = 'N-M08';

-- Test 3: UPDATE audit_log should FAIL
-- Expected: ERROR: permission denied for table audit_log
UPDATE audit_log SET old_value = 'TAMPERED' WHERE id = (SELECT id FROM audit_log LIMIT 1);

-- Test 4: Column-level UPDATE on status should SUCCEED
-- Expected: UPDATE 1 (success)
UPDATE knowledge_nodes SET status = 'REVIEW_REQUIRED' WHERE id = 'N-M02';
-- Reset it back for demo
UPDATE knowledge_nodes SET status = 'ACTIVE' WHERE id = 'N-M02';

-- Test 5: INSERT on both tables should SUCCEED
-- Expected: INSERT 0 1 (success)
INSERT INTO audit_log (node_id, action, old_value, new_value, actor_id, org_id)
VALUES ('N-M02', 'STATUS_CHANGE', 'ACTIVE', 'REVIEW_REQUIRED', 'U-MEERA', 'supra');

-- Test 6: TRUNCATE should FAIL
-- Expected: ERROR: permission denied for table knowledge_nodes
TRUNCATE knowledge_nodes;



After superseding, verify:
- N-M08 status = 'SUPERSEDED', superseded_by = 'N-M02'
- N-M02 status = 'ACTIVE'
- audit_log has entry: action='SUPERSEDE', node_id='N-M08', old_value contains "3 HOURS", new_value contains "1 HOUR"
- N-DRV-01 through N-DRV-06 status = 'REVIEW_REQUIRED' (cascade)
- N-DRV-04-A status = 'REVIEW_REQUIRED' (depth 2 cascade)



### Scenario 4: Point-in-Time Query

Query: "What did N-M08 say before it was superseded?"
```sql
SELECT old_value, timestamp, actor_id
FROM audit_log
WHERE node_id = 'N-M08'
  AND action = 'SUPERSEDE'
ORDER BY timestamp DESC LIMIT 1;
```
Returns: Full Sepsis v2 content, June 15 2026, Dr. Meera.