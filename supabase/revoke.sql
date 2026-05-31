-- Step 1: Revoke destructive operations on knowledge_nodes
-- The 'authenticated' role is what Supabase uses for logged-in users
REVOKE UPDATE, DELETE, TRUNCATE ON knowledge_nodes FROM authenticated;

-- Step 2: Grant column-level UPDATE for status transitions ONLY
-- This allows the SUPERSEDE pattern: mark old node status without full UPDATE
GRANT UPDATE(status, superseded_by) ON knowledge_nodes TO authenticated;

-- Step 3: Revoke ALL modifications on audit_log
-- The audit trail must be 100% immutable — even status changes aren't allowed
REVOKE UPDATE, DELETE, TRUNCATE ON audit_log FROM authenticated;

-- Step 4: Ensure INSERT still works on both tables
-- (INSERT is granted by default, but verify explicitly)
GRANT INSERT ON knowledge_nodes TO authenticated;
GRANT INSERT ON audit_log TO authenticated;
GRANT SELECT ON knowledge_nodes TO authenticated;
GRANT SELECT ON audit_log TO authenticated;

-- Step 5: Edges table — allow INSERT only (no UPDATE/DELETE for integrity)
REVOKE UPDATE, DELETE, TRUNCATE ON edges FROM authenticated;
GRANT INSERT, SELECT ON edges TO authenticated;


| UPDATE content | `UPDATE knowledge_nodes SET content='X' WHERE id='N-G01'` | ERROR: permission denied |
| DELETE node | `DELETE FROM knowledge_nodes WHERE id='N-M08'` | ERROR: permission denied |
| UPDATE audit | `UPDATE audit_log SET old_value='X'` | ERROR: permission denied |
| UPDATE status | `UPDATE knowledge_nodes SET status='SUPERSEDED' WHERE id='N-O02'` | SUCCESS |
| TRUNCATE | `TRUNCATE knowledge_nodes` | ERROR: permission denied |

