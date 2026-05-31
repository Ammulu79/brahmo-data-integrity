-- Organizations
CREATE TABLE organizations (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    config JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Knowledge Nodes (append-only — UPDATE/DELETE will be REVOKED)
CREATE TABLE knowledge_nodes (
    id TEXT PRIMARY KEY,
    org_id TEXT NOT NULL REFERENCES organizations(id),
    type TEXT NOT NULL CHECK (type IN ('CONSTRAINT', 'DECISION', 'ANTI_PATTERN', 'FACT')),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    importance DECIMAL(3,2) NOT NULL CHECK (importance BETWEEN 0.0 AND 1.0),
    status TEXT NOT NULL DEFAULT 'ACTIVE' CHECK (status IN (
        'ACTIVE', 'REVIEW_REQUIRED', 'SUPERSEDED', 'EXPIRED', 'LEGAL_HOLD'
    )),
    superseded_by TEXT REFERENCES knowledge_nodes(id),
    department TEXT,
    compliance_tags TEXT[] DEFAULT '{}',
    valid_until TIMESTAMPTZ,
    created_by TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Edges (for cascade invalidation testing)
CREATE TABLE edges (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    source_id TEXT NOT NULL REFERENCES knowledge_nodes(id),
    target_id TEXT NOT NULL REFERENCES knowledge_nodes(id),
    edge_type TEXT NOT NULL CHECK (edge_type IN (
        'SUPPORTS', 'CONTRADICTS', 'SUPERSEDES', 'DERIVED_FROM', 'REQUIRES'
    )),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Audit Log (append-only — UPDATE/DELETE will be REVOKED)
CREATE TABLE audit_log (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    node_id TEXT REFERENCES knowledge_nodes(id),
    action TEXT NOT NULL CHECK (action IN (
        'CREATE', 'SUPERSEDE', 'STATUS_CHANGE', 'LEGAL_HOLD',
        'LEGAL_RELEASE', 'ACCESS_LOGGED', 'CASCADE_SKIP'
    )),
    old_value TEXT,          -- FULL content snapshot (not a diff)
    new_value TEXT,          -- FULL content snapshot
    actor_id TEXT NOT NULL,
    actor_role TEXT,
    org_id TEXT NOT NULL,
    reason TEXT,             -- e.g., "Medico-legal case: Rajan vs Supra"
    metadata JSONB DEFAULT '{}',  -- additional context
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- Users (simplified for assessment)
CREATE TABLE users (
    id TEXT PRIMARY KEY,
    org_id TEXT NOT NULL REFERENCES organizations(id),
    name TEXT NOT NULL,
    role TEXT NOT NULL CHECK (role IN ('ADMIN', 'HOD', 'EDITOR', 'VIEWER')),
    department TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_nodes_org ON knowledge_nodes(org_id);
CREATE INDEX idx_nodes_status ON knowledge_nodes(status);
CREATE INDEX idx_nodes_dept ON knowledge_nodes(department);
CREATE INDEX idx_audit_node ON audit_log(node_id);
CREATE INDEX idx_audit_timestamp ON audit_log(timestamp);
CREATE INDEX idx_audit_action ON audit_log(action);
CREATE INDEX idx_audit_org ON audit_log(org_id);
CREATE INDEX idx_edges_source ON edges(source_id);
CREATE INDEX idx_edges_target ON edges(target_id);