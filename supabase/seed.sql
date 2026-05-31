INSERT INTO organizations (id, name, config) VALUES
('supra', 'Supra Multi-Specialty Hospital', '{"cascade_max_depth": 3}');

INSERT INTO users (id, org_id, name, role, department) VALUES
('U-MEERA',  'supra', 'Dr. Meera (HOD Medicine)',  'HOD',    'medicine'),
('U-VIKRAM', 'supra', 'Dr. Vikram (HOD Ortho)',     'HOD',    'ortho'),
('U-PRIYA',  'supra', 'Nurse Priya',                'VIEWER', 'ortho'),
('U-ANANYA', 'supra', 'Dr. Ananya (Junior)',         'EDITOR', 'medicine'),
('U-SURESH', 'supra', 'Admin Suresh',                'ADMIN',  'admin');


INSERT INTO knowledge_nodes (id, org_id, type, title, content, importance, status, department, compliance_tags, created_by, created_at) VALUES

('N-G01', 'supra', 'CONSTRAINT', 'Warfarin-NSAID Interaction',
 'CRITICAL: Never prescribe NSAIDs (ibuprofen, aspirin, diclofenac) to patients on Warfarin. Risk of life-threatening GI bleed. Alternative: Paracetamol for pain, PPI cover if anti-inflammatory needed. Supra policy: automatic pharmacy flag on co-prescription.',
 0.98, 'ACTIVE', NULL, '{}', 'U-MEERA', '2025-01-15 10:00:00+05:30'),

('N-G02', 'supra', 'CONSTRAINT', 'Blood Transfusion Two-Person Verification',
 'ALL blood transfusions require two-person verification of patient identity, blood type, and unit number. Single-person verification = protocol violation.',
 0.97, 'ACTIVE', NULL, '{}', 'U-VIKRAM', '2025-02-20 09:00:00+05:30'),

('N-M02', 'supra', 'DECISION', 'Sepsis Protocol v3 (2026)',
 'Supra Sepsis Bundle v3 (2026): blood cultures before antibiotics, lactate within 1 HOUR, 30mL/kg crystalloid for hypotension, vasopressors if MAP <65 after fluids. Updated from v2 which had 3-hour lactate window.',
 0.95, 'ACTIVE', 'medicine', '{}', 'U-MEERA', '2026-06-15 14:30:00+05:30'),

('N-O02', 'supra', 'DECISION', 'Paracetamol First-Line Post-TKR',
 'Supra Ortho uses Paracetamol 650mg QDS as first-line post-TKR pain management. Escalation: Tramadol 50mg if VAS > 6. AVOID NSAIDs due to bleeding risk at surgical site.',
 0.88, 'ACTIVE', 'ortho', '{}', 'U-VIKRAM', '2025-01-20 11:00:00+05:30'),

('N-O03', 'supra', 'ANTI_PATTERN', 'Never Discharge TKR Under 48 Hours',
 'Do NOT discharge TKR patients before 48 hours post-op. Past incident: patient discharged at 36 hours developed DVT at home.',
 0.91, 'ACTIVE', 'ortho', '{}', 'U-VIKRAM', '2025-03-10 08:00:00+05:30'),

('N-O06', 'supra', 'CONSTRAINT', 'DVT Prophylaxis Protocol',
 'ALL ortho surgical patients receive DVT prophylaxis: Enoxaparin 40mg SC daily starting 12 hours post-op. Duration: 14 days for TKR, 28 days for THR.',
 0.93, 'ACTIVE', 'ortho', '{}', 'U-VIKRAM', '2025-04-01 10:00:00+05:30'),

('N-M01', 'supra', 'CONSTRAINT', 'Diabetic Fasting Protocol',
 'For diabetic patients observing religious fasts: adjust insulin timing, NOT dose. Pre-fast: shift long-acting insulin to evening. During fast: monitor BG q4h.',
 0.90, 'ACTIVE', 'medicine', '{}', 'U-MEERA', '2025-06-01 09:00:00+05:30'),

('N-M03', 'supra', 'ANTI_PATTERN', 'Insulin Sliding Scale Alone',
 'Do NOT use insulin sliding scale as sole glycemic management. Past incident: DKA patient had only sliding scale, readmitted in 48 hours.',
 0.87, 'ACTIVE', 'medicine', '{}', 'U-ANANYA', '2025-07-15 14:00:00+05:30'),

-- ============================================================
-- SUPERSEDED NODE (Sepsis v2 — already replaced by v3)
-- ============================================================

('N-M08', 'supra', 'DECISION', 'Sepsis Protocol v2 (2024) — SUPERSEDED',
 'OLD: Supra Sepsis Bundle v2 (2024): blood cultures before antibiotics, lactate within 3 HOURS. SUPERSEDED by v3 which tightened lactate window to 1 hour.',
 0.95, 'SUPERSEDED', 'medicine', '{}', 'U-MEERA', '2024-03-01 10:00:00+05:30'),

-- ============================================================
-- PATIENT RAJAN NODES (for legal hold demo)
-- ============================================================

('N-O13', 'supra', 'FACT', 'Patient Rajan: Warfarin History',
 'Rajan, 68M. On Warfarin 5mg daily for AF. INR target 2.0-3.0. GI bleed history 2024 (NSAID interaction). STRICTLY NO NSAIDs. Current INR: 2.4.',
 0.88, 'ACTIVE', 'ortho', '{}', 'U-VIKRAM', '2024-06-15 09:00:00+05:30'),

('N-O14', 'supra', 'CONSTRAINT', 'Patient Rajan: Absolute NSAID Contraindication',
 'ABSOLUTE CONTRAINDICATION: No ibuprofen, no aspirin, no diclofenac for patient Rajan. Previous GI bleed 2024 was NSAID-induced while on Warfarin. Use Paracetamol ONLY.',
 0.99, 'ACTIVE', 'ortho', '{}', 'U-VIKRAM', '2024-06-16 10:00:00+05:30'),

-- ============================================================
-- NODES DERIVED FROM SEPSIS v2 (for cascade demo)
-- These should become REVIEW_REQUIRED when Sepsis v2 is superseded
-- ============================================================

('N-DRV-01', 'supra', 'DECISION', 'Medicine Ward Lactate Monitoring Schedule',
 'Lactate levels monitored per Sepsis v2 protocol: every 3 hours for suspected sepsis patients. ICU escalation if lactate > 4 mmol/L.',
 0.78, 'ACTIVE', 'medicine', '{}', 'U-ANANYA', '2024-05-10 11:00:00+05:30'),

('N-DRV-02', 'supra', 'DECISION', 'Night Shift Sepsis Screening Criteria',
 'Night shift nurses screen for sepsis using qSOFA (based on Sepsis v2 parameters): altered mentation, RR >= 22, SBP <= 100. If 2/3 present, call duty doctor.',
 0.75, 'ACTIVE', 'medicine', '{}', 'U-MEERA', '2024-06-20 08:00:00+05:30'),

('N-DRV-03', 'supra', 'DECISION', 'Emergency Antibiotic Selection for Sepsis',
 'Based on Sepsis v2 bundle: empiric Piperacillin-Tazobactam 4.5g IV within 3-hour window. Culture sensitivity guided de-escalation at 72 hours.',
 0.82, 'ACTIVE', 'medicine', '{}', 'U-MEERA', '2024-07-05 15:00:00+05:30'),

('N-DRV-04', 'supra', 'DECISION', 'ICU Admission Criteria from Sepsis Screening',
 'Derived from Sepsis v2: patients meeting 2/3 qSOFA criteria with lactate > 2 mmol/L should be assessed for ICU admission within 1 hour.',
 0.80, 'ACTIVE', 'medicine', '{}', 'U-ANANYA', '2024-08-12 10:00:00+05:30'),

('N-DRV-05', 'supra', 'FACT', 'Sepsis Mortality Rate Tracking (based on v2 protocol)',
 'Supra sepsis mortality Q3 2024: 18% (national average 22%). Improvement attributed to v2 bundle compliance reaching 78%.',
 0.60, 'ACTIVE', 'medicine', '{}', 'U-MEERA', '2024-10-01 09:00:00+05:30'),

('N-DRV-06', 'supra', 'DECISION', 'Pharmacy Pre-Authorization for IV Antibiotics',
 'Per Sepsis v2 bundle timing requirements: pharmacy pre-authorizes Pip-Tazo for suspected sepsis cases. No approval delay for empiric treatment within 3-hour window.',
 0.72, 'ACTIVE', 'medicine', '{}', 'U-ANANYA', '2024-11-15 14:00:00+05:30'),

-- ============================================================
-- CONFIDENTIAL ADMIN NODES (for compliance demo)
-- ============================================================

('N-A01', 'supra', 'DECISION', 'Hospital Expansion Plan 2026-2028',
 'Board-approved: 80 additional beds by Q4 2027. New Oncology wing. Total investment: ₹85 Cr. STRICTLY CONFIDENTIAL.',
 0.80, 'ACTIVE', NULL, '{"MNPI", "CONFIDENTIAL"}', 'U-SURESH', '2026-01-10 10:00:00+05:30'),

('N-A04', 'supra', 'CONSTRAINT', 'Legal Case: Rajan Medico-Legal Hold',
 'LEGAL HOLD: All records related to patient Rajan (2024 GI bleed incident) are under medico-legal hold. NO modification, NO deletion, NO status change.',
 0.95, 'ACTIVE', NULL, '{"CONFIDENTIAL"}', 'U-SURESH', '2026-05-01 10:00:00+05:30'),

-- ============================================================
-- NODE TO BE SUPERSEDED DURING DEMO
-- (Warfarin constraint — for surprise test correction scenario)
-- ============================================================

('N-G01-ORIG', 'supra', 'CONSTRAINT', 'Warfarin Interaction — Original Version',
 'Warfarin patients: avoid NSAIDs. Cross-reactivity with cephalosporins: 15% (NOTE: this percentage may be inaccurate).',
 0.95, 'ACTIVE', NULL, '{}', 'U-MEERA', '2024-01-01 10:00:00+05:30');
```

Update superseded_by for the already-superseded node:


UPDATE knowledge_nodes SET superseded_by = 'N-M02' WHERE id = 'N-M08';


INSERT INTO edges (source_id, target_id, edge_type) VALUES
('N-DRV-01', 'N-M08', 'DERIVED_FROM'),  -- Lactate schedule derived from Sepsis v2
('N-DRV-02', 'N-M08', 'DERIVED_FROM'),  -- Night shift screening from Sepsis v2
('N-DRV-03', 'N-M08', 'DERIVED_FROM'),  -- Antibiotic selection from Sepsis v2
('N-DRV-04', 'N-M08', 'DERIVED_FROM'),  -- ICU admission from Sepsis v2
('N-DRV-05', 'N-M08', 'DERIVED_FROM'),  -- Mortality tracking from Sepsis v2
('N-DRV-06', 'N-M08', 'DERIVED_FROM'),  -- Pharmacy pre-auth from Sepsis v2

-- Deeper cascade: DRV-04 has its own derivative (depth 2)
('N-DRV-04-A', 'N-DRV-04', 'DERIVED_FROM'),

-- SUPPORTS relationships
('N-O06', 'N-O02', 'SUPPORTS'),          -- DVT prophylaxis supports Paracetamol decision
('N-O14', 'N-G01', 'DERIVED_FROM'),      -- Rajan NSAID ban derived from global Warfarin rule
('N-G01', 'N-G01-ORIG', 'SUPERSEDES');   -- Current Warfarin rule supersedes original
```


INSERT INTO knowledge_nodes (id, org_id, type, title, content, importance, status, department, created_by, created_at) VALUES
('N-DRV-04-A', 'supra', 'DECISION', 'ICU Bed Reservation Protocol for Sepsis',
 'Based on ICU admission criteria (N-DRV-04): reserve 2 ICU beds per shift for suspected sepsis admissions. Coordinate with bed manager.',
 0.65, 'ACTIVE', 'medicine', 'U-ANANYA', '2025-01-20 10:00:00+05:30');
```

---

## SEED DATA — INITIAL AUDIT ENTRIES


-- ============================================================
-- Pre-load some audit entries for the timeline demo
-- ============================================================

INSERT INTO audit_log (node_id, action, old_value, new_value, actor_id, actor_role, org_id, reason, timestamp) VALUES

('N-M08', 'CREATE', NULL,
 'Supra Sepsis Bundle v2 (2024): blood cultures before antibiotics, lactate within 3 HOURS.',
 'U-MEERA', 'HOD', 'supra', 'Initial protocol creation', '2024-03-01 10:00:00+05:30'),

('N-M08', 'SUPERSEDE',
 'Supra Sepsis Bundle v2 (2024): blood cultures before antibiotics, lactate within 3 HOURS.',
 'Supra Sepsis Bundle v3 (2026): blood cultures before antibiotics, lactate within 1 HOUR, 30mL/kg crystalloid for hypotension.',
 'U-MEERA', 'HOD', 'supra', 'Tightened lactate window based on SCCM 2025 guidelines', '2026-06-15 14:30:00+05:30'),

('N-M02', 'CREATE', NULL,
 'Supra Sepsis Bundle v3 (2026): blood cultures before antibiotics, lactate within 1 HOUR.',
 'U-MEERA', 'HOD', 'supra', 'New Sepsis Protocol replacing v2', '2026-06-15 14:30:00+05:30'),

('N-O14', 'CREATE', NULL,
 'ABSOLUTE CONTRAINDICATION: No ibuprofen, no aspirin, no diclofenac for patient Rajan.',
 'U-VIKRAM', 'HOD', 'supra', 'Documented after 2024 GI bleed incident', '2024-06-16 10:00:00+05:30'),

('N-G01', 'CREATE', NULL,
 'CRITICAL: Never prescribe NSAIDs to patients on Warfarin.',
 'U-MEERA', 'HOD', 'supra', 'Hospital-wide drug safety constraint', '2025-01-15 10:00:00+05:30');
