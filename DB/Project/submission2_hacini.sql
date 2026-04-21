-- Submission 2 - Database Implementation
-- DBMS: SQLite 3
-- Domain: Academic Conference Submission Platform

PRAGMA foreign_keys = ON;

DROP TRIGGER IF EXISTS paper_status_requires_content;
DROP TRIGGER IF EXISTS paper_insert_starts_as_draft;
DROP TRIGGER IF EXISTS review_reviewer_is_not_author_insert;
DROP TRIGGER IF EXISTS review_reviewer_is_not_author_update;

DROP TABLE IF EXISTS review;
DROP TABLE IF EXISTS authorship;
DROP TABLE IF EXISTS paper_version;
DROP TABLE IF EXISTS paper;
DROP TABLE IF EXISTS reviewer;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS institution;

CREATE TABLE institution (
  institution_id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  country TEXT NOT NULL,
  CHECK (length(trim(name)) > 0),
  CHECK (length(trim(country)) > 0)
);

CREATE TABLE person (
  person_id INTEGER PRIMARY KEY,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  CHECK (length(trim(full_name)) > 0),
  CHECK (length(trim(email)) > 0),
  CHECK (instr(email, '@') > 1)
);

CREATE TABLE author (
  person_id INTEGER PRIMARY KEY,
  institution_id INTEGER NOT NULL,
  orcid TEXT NOT NULL UNIQUE,
  FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE,
  FOREIGN KEY (institution_id) REFERENCES institution(institution_id),
  CHECK (length(trim(orcid)) > 0)
);

CREATE TABLE reviewer (
  person_id INTEGER PRIMARY KEY,
  expertise_area TEXT NOT NULL,
  max_load INTEGER NOT NULL,
  FOREIGN KEY (person_id) REFERENCES person(person_id) ON DELETE CASCADE,
  CHECK (length(trim(expertise_area)) > 0),
  CHECK (max_load > 0)
);

CREATE TABLE track (
  track_id INTEGER PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  description TEXT NOT NULL,
  CHECK (length(trim(name)) > 0),
  CHECK (length(trim(description)) > 0)
);

CREATE TABLE paper (
  paper_id INTEGER PRIMARY KEY,
  track_id INTEGER NOT NULL,
  title TEXT NOT NULL,
  abstract TEXT NOT NULL,
  status TEXT NOT NULL,
  submitted_on TEXT NOT NULL,
  FOREIGN KEY (track_id) REFERENCES track(track_id),
  CHECK (length(trim(title)) > 0),
  CHECK (length(trim(abstract)) > 0),
  CHECK (status IN (
    'draft',
    'submitted',
    'under_review',
    'accepted',
    'rejected',
    'camera_ready'
  )),
  CHECK (date(submitted_on) IS NOT NULL)
);

CREATE TABLE paper_version (
  paper_id INTEGER NOT NULL,
  version_no INTEGER NOT NULL,
  uploaded_at TEXT NOT NULL,
  file_name TEXT NOT NULL,
  checksum TEXT NOT NULL,
  PRIMARY KEY (paper_id, version_no),
  FOREIGN KEY (paper_id) REFERENCES paper(paper_id) ON DELETE CASCADE,
  CHECK (version_no >= 1),
  CHECK (datetime(uploaded_at) IS NOT NULL),
  CHECK (length(trim(file_name)) > 0),
  CHECK (length(trim(checksum)) > 0)
);

CREATE TABLE authorship (
  paper_id INTEGER NOT NULL,
  author_id INTEGER NOT NULL,
  author_order INTEGER NOT NULL,
  PRIMARY KEY (paper_id, author_id),
  UNIQUE (paper_id, author_order),
  FOREIGN KEY (paper_id) REFERENCES paper(paper_id) ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES author(person_id),
  CHECK (author_order >= 1)
);

CREATE TABLE review (
  paper_id INTEGER NOT NULL,
  reviewer_id INTEGER NOT NULL,
  score INTEGER NOT NULL,
  confidence INTEGER NOT NULL,
  recommendation TEXT NOT NULL,
  submitted_at TEXT,
  PRIMARY KEY (paper_id, reviewer_id),
  FOREIGN KEY (paper_id) REFERENCES paper(paper_id) ON DELETE CASCADE,
  FOREIGN KEY (reviewer_id) REFERENCES reviewer(person_id),
  CHECK (score BETWEEN 1 AND 5),
  CHECK (confidence BETWEEN 1 AND 5),
  CHECK (recommendation IN ('accept', 'weak_accept', 'weak_reject', 'reject')),
  CHECK (submitted_at IS NULL OR datetime(submitted_at) IS NOT NULL)
);

-- A paper must be created as draft and can leave draft only after at least one
-- author and one version exist.
CREATE TRIGGER paper_insert_starts_as_draft
BEFORE INSERT ON paper
FOR EACH ROW
WHEN NEW.status <> 'draft'
BEGIN
  SELECT RAISE(ABORT, 'paper must be inserted with draft status');
END;

CREATE TRIGGER paper_status_requires_content
BEFORE UPDATE OF status ON paper
FOR EACH ROW
WHEN NEW.status <> 'draft'
 AND (
   NOT EXISTS (
     SELECT 1
     FROM authorship a
     WHERE a.paper_id = NEW.paper_id
   )
   OR NOT EXISTS (
     SELECT 1
     FROM paper_version pv
     WHERE pv.paper_id = NEW.paper_id
   )
 )
BEGIN
  SELECT RAISE(ABORT, 'paper needs at least one author and one version before leaving draft');
END;

-- a reviewer cannot review a paper they co-authored.
CREATE TRIGGER review_reviewer_is_not_author_insert
BEFORE INSERT ON review
FOR EACH ROW
WHEN EXISTS (
  SELECT 1
  FROM authorship a
  WHERE a.paper_id = NEW.paper_id
    AND a.author_id = NEW.reviewer_id
)
BEGIN
  SELECT RAISE(ABORT, 'reviewer cannot review a paper they authored');
END;

CREATE TRIGGER review_reviewer_is_not_author_update
BEFORE UPDATE OF paper_id, reviewer_id ON review
FOR EACH ROW
WHEN EXISTS (
  SELECT 1
  FROM authorship a
  WHERE a.paper_id = NEW.paper_id
    AND a.author_id = NEW.reviewer_id
)
BEGIN
  SELECT RAISE(ABORT, 'reviewer cannot review a paper they authored');
END;

BEGIN TRANSACTION;

INSERT INTO institution (institution_id, name, country) VALUES
  (1, 'Universite Grenoble Alpes', 'France'),
  (2, 'EPFL', 'Switzerland'),
  (3, 'University of Milan', 'Italy');

INSERT INTO track (track_id, name, description) VALUES
  (1, 'Database Systems', 'Storage, query processing, and transaction management.'),
  (2, 'Data Mining', 'Pattern discovery, graph analysis, and explainability.'),
  (3, 'AI for Science', 'Machine learning methods supporting scientific workflows.');

INSERT INTO person (person_id, full_name, email) VALUES
  (1, 'Alice Martin', 'alice.martin@example.org'),
  (2, 'Bruno Rossi', 'bruno.rossi@example.org'),
  (3, 'Chloe Bernard', 'chloe.bernard@example.org'),
  (4, 'David Kim', 'david.kim@example.org'),
  (5, 'Emma Dubois', 'emma.dubois@example.org'),
  (6, 'Farid Benali', 'farid.benali@example.org'),
  (7, 'Grace Lee', 'grace.lee@example.org'),
  (8, 'Hugo Morel', 'hugo.morel@example.org');

INSERT INTO author (person_id, institution_id, orcid) VALUES
  (1, 1, '0000-0001-1000-0001'),
  (2, 2, '0000-0001-1000-0002'),
  (3, 1, '0000-0001-1000-0003'),
  (5, 3, '0000-0001-1000-0005'),
  (7, 2, '0000-0001-1000-0007'),
  (8, 1, '0000-0001-1000-0008');

INSERT INTO reviewer (person_id, expertise_area, max_load) VALUES
  (3, 'Database Systems', 3),
  (4, 'Responsible AI', 2),
  (6, 'Data Mining', 3),
  (7, 'Scientific Workflows', 2);

INSERT INTO paper (paper_id, track_id, title, abstract, status, submitted_on) VALUES
  (101, 1, 'Adaptive Indexing for Edge Databases', 'A lightweight indexing strategy for constrained edge nodes.', 'draft', '2026-03-02'),
  (102, 2, 'Explainable Graph Mining for Climate Risk', 'A graph mining pipeline with interpretable risk explanations.', 'draft', '2026-03-05'),
  (103, 1, 'Low-Cost Benchmarking for Reproducible SQL Teaching', 'A benchmark suite designed for classroom-scale relational experiments.', 'draft', '2026-03-08'),
  (104, 3, 'Scientific Peer Review Assistant with Human Oversight', 'Decision support for review assignment and score analysis.', 'draft', '2026-03-10');

INSERT INTO paper_version (paper_id, version_no, uploaded_at, file_name, checksum) VALUES
  (101, 1, '2026-03-02 09:00:00', 'paper_101_v1.pdf', 'sha256-101-v1'),
  (101, 2, '2026-03-07 15:30:00', 'paper_101_v2.pdf', 'sha256-101-v2'),
  (102, 1, '2026-03-05 11:00:00', 'paper_102_v1.pdf', 'sha256-102-v1'),
  (103, 1, '2026-03-08 14:15:00', 'paper_103_v1.pdf', 'sha256-103-v1'),
  (104, 1, '2026-03-10 10:45:00', 'paper_104_v1.pdf', 'sha256-104-v1'),
  (104, 2, '2026-03-14 17:20:00', 'paper_104_v2.pdf', 'sha256-104-v2');

INSERT INTO authorship (paper_id, author_id, author_order) VALUES
  (101, 1, 1),
  (101, 2, 2),
  (102, 5, 1),
  (102, 3, 2),
  (103, 8, 1),
  (103, 1, 2),
  (104, 7, 1),
  (104, 2, 2);

INSERT INTO review (paper_id, reviewer_id, score, confidence, recommendation, submitted_at) VALUES
  (101, 3, 4, 4, 'weak_accept', '2026-03-15 10:00:00'),
  (101, 4, 5, 3, 'accept', '2026-03-15 14:30:00'),
  (102, 4, 4, 4, 'weak_accept', '2026-03-16 09:20:00'),
  (102, 6, 5, 5, 'accept', '2026-03-16 11:40:00'),
  (103, 3, 3, 4, 'weak_reject', '2026-03-17 13:10:00'),
  (103, 7, 4, 3, 'weak_accept', '2026-03-17 16:50:00'),
  (104, 3, 2, 3, 'reject', '2026-03-18 10:05:00'),
  (104, 6, 3, 4, 'weak_reject', '2026-03-18 15:25:00');

UPDATE paper SET status = 'under_review' WHERE paper_id = 101;
UPDATE paper SET status = 'accepted' WHERE paper_id = 102;
UPDATE paper SET status = 'submitted' WHERE paper_id = 103;
UPDATE paper SET status = 'rejected' WHERE paper_id = 104;

COMMIT;

.headers on
.mode column

-- ---------------------------------------------------------------------------
-- Query 1
-- list the submitted papers with their track and current workflow state.
-- Relational algebra:
-- pi_{paper_id, title, track_name, status}
--   ( PAPER join_{PAPER.track_id = TRACK.track_id} TRACK )
SELECT
  p.paper_id,
  p.title,
  t.name AS track_name,
  p.status
FROM paper AS p
JOIN track AS t ON t.track_id = p.track_id
ORDER BY p.paper_id;

-- Expected result:
-- 101 | Adaptive Indexing for Edge Databases               | Database Systems | under_review
-- 102 | Explainable Graph Mining for Climate Risk          | Data Mining      | accepted
-- 103 | Low-Cost Benchmarking for Reproducible SQL Teaching| Database Systems | submitted
-- 104 | Scientific Peer Review Assistant with Human Oversight | AI for Science | rejected

-- ---------------------------------------------------------------------------
-- Query 2
-- show the author list of each paper in the correct order.
-- Relational algebra:
-- pi_{paper_title, author_order, full_name}
--   ( PAPER join AUTHORSHIP join AUTHOR join PERSON )
SELECT
  p.title,
  a.author_order,
  pe.full_name AS author_name
FROM authorship AS a
JOIN paper AS p ON p.paper_id = a.paper_id
JOIN author AS au ON au.person_id = a.author_id
JOIN person AS pe ON pe.person_id = au.person_id
ORDER BY p.paper_id, a.author_order;

-- Expected result:
-- Adaptive Indexing for Edge Databases                | 1 | Alice Martin
-- Adaptive Indexing for Edge Databases                | 2 | Bruno Rossi
-- Explainable Graph Mining for Climate Risk           | 1 | Emma Dubois
-- Explainable Graph Mining for Climate Risk           | 2 | Chloe Bernard
-- Low-Cost Benchmarking for Reproducible SQL Teaching | 1 | Hugo Morel
-- Low-Cost Benchmarking for Reproducible SQL Teaching | 2 | Alice Martin
-- Scientific Peer Review Assistant with Human Oversight | 1 | Grace Lee
-- Scientific Peer Review Assistant with Human Oversight | 2 | Bruno Rossi

-- ---------------------------------------------------------------------------
-- Query 3
-- inspect the evaluations received by one paper.
-- Relational algebra:
-- pi_{paper_title, reviewer_name, score, recommendation}
--   ( sigma_{title = 'Adaptive Indexing for Edge Databases'}(PAPER)
--     join REVIEW join REVIEWER join PERSON )
SELECT
  p.title,
  pe.full_name AS reviewer_name,
  r.score,
  r.recommendation
FROM review AS r
JOIN paper AS p ON p.paper_id = r.paper_id
JOIN reviewer AS rv ON rv.person_id = r.reviewer_id
JOIN person AS pe ON pe.person_id = rv.person_id
WHERE p.title = 'Adaptive Indexing for Edge Databases'
ORDER BY pe.full_name;

-- Expected result:
-- Adaptive Indexing for Edge Databases | Chloe Bernard | 4 | weak_accept
-- Adaptive Indexing for Edge Databases | David Kim     | 5 | accept

-- ---------------------------------------------------------------------------
-- Query 4
-- list the papers co-authored by researchers from Universite Grenoble Alpes.
-- Relational algebra:
-- pi_{full_name, paper_title}
--   ( sigma_{institution_name = 'Universite Grenoble Alpes'}
--     ( INSTITUTION join AUTHOR join PERSON join AUTHORSHIP join PAPER ) )
SELECT
  pe.full_name AS author_name,
  p.title
FROM institution AS i
JOIN author AS au ON au.institution_id = i.institution_id
JOIN person AS pe ON pe.person_id = au.person_id
JOIN authorship AS a ON a.author_id = au.person_id
JOIN paper AS p ON p.paper_id = a.paper_id
WHERE i.name = 'Universite Grenoble Alpes'
ORDER BY pe.full_name, p.title;

-- Expected result:
-- Alice Martin  | Adaptive Indexing for Edge Databases
-- Alice Martin  | Low-Cost Benchmarking for Reproducible SQL Teaching
-- Chloe Bernard | Explainable Graph Mining for Climate Risk
-- Hugo Morel    | Low-Cost Benchmarking for Reproducible SQL Teaching

-- ---------------------------------------------------------------------------
-- Query 5
-- identify papers reviewed by people who are also registered as authors.
-- Relational algebra:
-- pi_{reviewer_name, paper_title}
--   ( REVIEW join REVIEWER join AUTHOR join PERSON join PAPER )
SELECT DISTINCT
  pe.full_name AS reviewer_name,
  p.title
FROM review AS r
JOIN reviewer AS rv ON rv.person_id = r.reviewer_id
JOIN author AS au ON au.person_id = rv.person_id
JOIN person AS pe ON pe.person_id = rv.person_id
JOIN paper AS p ON p.paper_id = r.paper_id
ORDER BY pe.full_name, p.title;

-- Expected result:
-- Chloe Bernard | Adaptive Indexing for Edge Databases
-- Chloe Bernard | Low-Cost Benchmarking for Reproducible SQL Teaching
-- Chloe Bernard | Scientific Peer Review Assistant with Human Oversight
-- Grace Lee     | Low-Cost Benchmarking for Reproducible SQL Teaching

-- ---------------------------------------------------------------------------
-- Query 6
-- count how many papers are assigned to each track.
SELECT
  t.name AS track_name,
  COUNT(p.paper_id) AS paper_count
FROM track AS t
LEFT JOIN paper AS p ON p.track_id = t.track_id
GROUP BY t.track_id, t.name
ORDER BY t.track_id;

-- Expected result:
-- Database Systems | 2
-- Data Mining      | 1
-- AI for Science   | 1

-- ---------------------------------------------------------------------------
-- Query 7
-- compute the average score and the number of reviews for each paper.
SELECT
  p.title,
  ROUND(AVG(r.score), 2) AS average_score,
  COUNT(*) AS review_count
FROM paper AS p
JOIN review AS r ON r.paper_id = p.paper_id
GROUP BY p.paper_id, p.title
ORDER BY average_score DESC, p.title;

-- Expected result:
-- Explainable Graph Mining for Climate Risk           | 4.5 | 2
-- Adaptive Indexing for Edge Databases                | 4.5 | 2
-- Low-Cost Benchmarking for Reproducible SQL Teaching | 3.5 | 2
-- Scientific Peer Review Assistant with Human Oversight | 2.5 | 2

-- ---------------------------------------------------------------------------
-- Query 8
-- measure reviewer workload and average confidence.
SELECT
  pe.full_name AS reviewer_name,
  COUNT(r.paper_id) AS reviews_written,
  ROUND(AVG(r.confidence), 2) AS average_confidence
FROM reviewer AS rv
JOIN person AS pe ON pe.person_id = rv.person_id
LEFT JOIN review AS r ON r.reviewer_id = rv.person_id
GROUP BY rv.person_id, pe.full_name
ORDER BY reviews_written DESC, reviewer_name;

-- Expected result:
-- Chloe Bernard | 3 | 3.67
-- David Kim     | 2 | 3.50
-- Farid Benali  | 2 | 4.50
-- Grace Lee     | 1 | 3.00
