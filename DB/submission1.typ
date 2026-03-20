#import "@preview/pintorita:0.1.4"

#set page(
  paper: "a4",
  margin: (top: 1.8cm, bottom: 1.8cm, x: 2cm),
  numbering: "1",
)

#set text(font: "Libertinus Serif", size: 10.5pt)
#set par(justify: true, leading: 0.6em)
#set heading(numbering: "1.")
#set list(spacing: 0.35em)

#show raw.where(lang: "pintora"): it => pintorita.render(
  it.text,
  factor: 0.54,
  style: "default",
)

#align(center)[
  #text(16pt, weight: "bold")[Submission 1 - Database Design] \
  #text(12pt, style: "italic")[Academic Conference Submission Platform] \
  #text(10.5pt)[Malik Hacini]
]

#v(1.1em)

Conceptual and relational design for an academic conference submission
platform. The model covers participants, affiliations, tracks, papers,
submission versions, ordered authorship, and review evaluations.

= Motivation

The platform manages the full path of a conference paper: author registration,
affiliation, submission to a track, version history, ordered co-authorship, and
peer review. The design separates shared identity data from role-specific data,
keeps affiliations and tracks normalized, and stores the two central process
links as association entities: `Authorship` for author order and `Review` for
evaluation. `PaperVersion` records the evolution of each submission without
duplicating paper metadata.

= UML Design

#figure(
  kind: "diagram",
  supplement: [Figure],
  caption: [UML class diagram of the conference submission platform.],
  ```pintora
classDiagram
  class Person {
    <<abstract>>
    int person_id
    string full_name
    string email
  }

  class Author {
    string orcid
  }

  class Reviewer {
    string expertise_area
    int max_load
  }

  class Institution {
    int institution_id
    string name
    string country
  }

  class Track {
    int track_id
    string name
    string description
  }

  class Paper {
    int paper_id
    string title
    string abstract
    string status
    date submitted_on
  }

  class PaperVersion {
    int version_no
    datetime uploaded_at
    string file_name
    string checksum
  }

  class Authorship {
    int author_order
  }

  class Review {
    int score
    int confidence
    string recommendation
    datetime submitted_at
  }

  Person <|-- Author
  Person <|-- Reviewer
  Institution "1" <-- "0..*" Author : affiliation
  Track "1" <-- "0..*" Paper : submission track
  Paper "1" *-- "1..*" PaperVersion : version history
  Author "1" <-- "0..*" Authorship : author link
  Paper "1" <-- "1..*" Authorship : paper link
  Reviewer "1" <-- "0..*" Review : writes
  Paper "1" <-- "0..*" Review : receives
  ```
)

== Modeling Choices

- `Person` stores the common identity attributes shared by all participants.
- `Author` and `Reviewer` specialize `Person`; one individual may appear in both roles.
- `Institution` is separated from `Author` so affiliations are normalized.
- `Track` groups papers by topic and gives each submission a single destination.
- `Paper` is the central object of the system.
- `PaperVersion` records the submission history of a paper; its identifier is `(paper_id, version_no)`.
- `Authorship` models the many-to-many link between `Author` and `Paper` and carries `author_order`.
- `Review` models the many-to-many link between `Reviewer` and `Paper` and stores the evaluation itself.

== Cardinalities and Identifiers

- One `Institution` can be linked to zero or more authors; each `Author` has exactly one institution.
- One `Track` can receive zero or more papers; each `Paper` belongs to exactly one track.
- One `Paper` owns one or more `PaperVersion` rows; each `PaperVersion` belongs to exactly one paper.
- One `Author` can appear in zero or more `Authorship` rows; each `Paper` must have one or more authorship rows.
- One `Reviewer` can write zero or more reviews; a `Paper` can receive zero or more reviews while it is awaiting evaluation.
- Main identifiers are: `person_id`, `institution_id`, `track_id`, `paper_id`, `(paper_id, version_no)`, `(paper_id, author_id)`, and `(paper_id, reviewer_id)`.

= Relational Schema

#figure(
  kind: "diagram",
  supplement: [Figure],
  caption: [Relational view derived from the UML model.],
  ```pintora
erDiagram
  PERSON {
    int person_id PK
    string full_name
    string email
  }

  AUTHOR {
    int person_id PK
    string orcid
    int institution_id FK
  }

  REVIEWER {
    int person_id PK
    string expertise_area
    int max_load
  }

  INSTITUTION {
    int institution_id PK
    string name
    string country
  }

  TRACK {
    int track_id PK
    string name
    string description
  }

  PAPER {
    int paper_id PK
    int track_id FK
    string title
    string status
    date submitted_on
  }

  PAPER_VERSION {
    int paper_id PK
    int version_no PK
    datetime uploaded_at
    string file_name
  }

  AUTHORSHIP {
    int paper_id PK
    int author_id PK
    int author_order
  }

  REVIEW {
    int paper_id PK
    int reviewer_id PK
    int score
    int confidence
    string recommendation
  }

  AUTHOR inherit PERSON
  REVIEWER inherit PERSON
  INSTITUTION ||--o{ AUTHOR : hosts
  TRACK ||--o{ PAPER : classifies
  PAPER ||--|{ PAPER_VERSION : stores
  AUTHOR ||--o{ AUTHORSHIP : signs
  PAPER ||--|{ AUTHORSHIP : has
  REVIEWER ||--o{ REVIEW : writes
  PAPER ||--o{ REVIEW : receives
  ```
)

== Relations

- `INSTITUTION(institution_id, name, country)`; primary key `institution_id`; `name` is unique.
- `PERSON(person_id, full_name, email)`; primary key `person_id`; `email` is unique.
- `AUTHOR(person_id, institution_id, orcid)`; primary key `person_id`; foreign keys `person_id -> PERSON.person_id` and `institution_id -> INSTITUTION.institution_id`; `orcid` is unique.
- `REVIEWER(person_id, expertise_area, max_load)`; primary key `person_id`; foreign key `person_id -> PERSON.person_id`.
- `TRACK(track_id, name, description)`; primary key `track_id`; `name` is unique.
- `PAPER(paper_id, track_id, title, abstract, status, submitted_on)`; primary key `paper_id`; foreign key `track_id -> TRACK.track_id`.
- `PAPER_VERSION(paper_id, version_no, uploaded_at, file_name, checksum)`; primary key `(paper_id, version_no)`; foreign key `paper_id -> PAPER.paper_id`.
- `AUTHORSHIP(paper_id, author_id, author_order)`; primary key `(paper_id, author_id)`; foreign keys `paper_id -> PAPER.paper_id` and `author_id -> AUTHOR.person_id`; `(paper_id, author_order)` is unique.
- `REVIEW(paper_id, reviewer_id, score, confidence, recommendation, submitted_at)`; primary key `(paper_id, reviewer_id)`; foreign keys `paper_id -> PAPER.paper_id` and `reviewer_id -> REVIEWER.person_id`.

== Integrity Constraints

- All primary key and foreign key attributes are `NOT NULL`.
- `AUTHOR.person_id` and `REVIEWER.person_id` are subsets of `PERSON.person_id`.
- `AUTHOR.institution_id` is a subset of `INSTITUTION.institution_id`, and `PAPER.track_id` is a subset of `TRACK.track_id`.
- `PAPER_VERSION.paper_id`, `AUTHORSHIP.paper_id`, `AUTHORSHIP.author_id`, `REVIEW.paper_id`, and `REVIEW.reviewer_id` must all satisfy referential integrity.
- `REVIEWER.max_load > 0`, `PAPER_VERSION.version_no >= 1`, and `AUTHORSHIP.author_order >= 1`.
- `REVIEW.score` and `REVIEW.confidence` are integers in the range `1..5`.
- `PAPER.status` belongs to `{draft, submitted, under_review, accepted, rejected, camera_ready}`.
- `REVIEW.recommendation` belongs to `{accept, weak_accept, weak_reject, reject}`.
- `PERSON.email`, `AUTHOR.orcid`, `TRACK.name`, `INSTITUTION.name`, and `(paper_id, author_order)` in `AUTHORSHIP` are unique.
- Two additional business constraints should be enforced during implementation with assertions or triggers: every paper must have at least one author and one version, and a reviewer cannot review a paper they co-authored.
