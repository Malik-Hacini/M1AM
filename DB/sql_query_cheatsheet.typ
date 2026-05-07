#set page(
  paper: "a4",
  margin: (top: 1.1cm, bottom: 1.1cm, x: 1.2cm),
  numbering: "1",
)

#set text(font: "Libertinus Serif", size: 8.45pt)
#set par(justify: true, leading: 0.4em)
#set heading(numbering: none)
#set raw(tab-size: 2)
#set table(
  inset: (x: 3.2pt, y: 2.5pt),
  stroke: 0.35pt + luma(165),
)

#let h(body) = table.cell(fill: luma(232))[#strong(body)]

#align(center)[
  #text(17pt, weight: "bold")[SQL Query Writing]
  #linebreak()
  #text(10pt, style: "italic")[Exam cheatsheet: relational algebra equivalences, methods, traps, and solved querying exercise]
]

#v(0.5em)

SQL is close to relational algebra, but not identical. Relational algebra uses set semantics by default, while SQL uses bag semantics unless `DISTINCT` or a set operator removes duplicates. In the exam, write the simplest correct query, make joins explicit, and state when `DISTINCT` is needed.

= SQL Skeleton And Logical Order

The written order and the evaluation order are different. This matters for `WHERE`, `GROUP BY`, `HAVING`, and aliases.

#table(
  columns: (1fr, 2.2fr, 3.1fr),
  table.header(h[Clause], h[Role], h[Exam rule]),
  [`FROM` and `JOIN`], [Build the input relation by combining tables.], [Put relationship conditions in `ON` or `USING`; qualify attributes when names repeat.],
  [`WHERE`], [Filter individual rows before grouping.], [Use for normal predicates such as `stars >= 4`, `Name = 'Peter'`, or join-independent filters.],
  [`GROUP BY`], [Partition rows into groups.], [Every non-aggregate expression in `SELECT` must appear in `GROUP BY`.],
  [`HAVING`], [Filter groups after aggregation.], [Use for aggregate predicates such as `COUNT(*) > 1` or `AVG(Rating) = ...`.],
  [`SELECT`], [Choose output expressions.], [Use aggregate functions only with the correct grouping rule.],
  [`DISTINCT`], [Remove duplicate output rows.], [Needed when SQL bag semantics can output duplicates but the relational answer is a set.],
  [`ORDER BY`], [Sort final result.], [Usually not needed unless the question asks for an order.],
)

The practical order to design a query is different again: decide the output attributes, identify source tables, write joins, add filters, decide whether grouping is needed, decide whether duplicates can appear, then simplify.

= Relational Algebra To SQL Equivalences

#table(
  columns: (1.15fr, 2.25fr, 3.05fr),
  table.header(h[Relational algebra], h[SQL pattern], h[Important difference]),
  [`R[A,B]`], [`SELECT DISTINCT A, B FROM R`], [Use `DISTINCT` if you want set semantics. Without it, SQL may keep duplicates.],
  [`R:P`], [`SELECT * FROM R WHERE P`], [Rows where `P` is false or unknown are discarded. This matters with `NULL`.],
  [`R * S`], [`FROM R JOIN S USING (common_attribute)`], [Natural join in RA joins on all common names. In SQL, `USING` joins only listed names.],
  [`R(P)*S`], [`FROM R JOIN S ON (P)`], [Use `ON` when names differ or the condition is not just equality on same names.],
  [`R x S`], [`FROM R CROSS JOIN S`], [Rarely useful alone; most queries need a join condition.],
  [`T(X,Y) <- R`], [`FROM R AS T` or `SELECT A AS X`], [Aliases are mandatory for self-joins.],
  [`R union S`], [`query1 UNION query2`], [`UNION` removes duplicates; `UNION ALL` keeps them.],
  [`R intersect S`], [`query1 INTERSECT query2`], [Inputs must have compatible schemas.],
  [`R - S`], [`query1 EXCEPT query2` or Oracle `MINUS`], [Set difference is the cleanest way to express "never" or "not in" when schemas match.],
  [`R / S`], [`GROUP BY ... HAVING COUNT(DISTINCT ...) = ...` or double `NOT EXISTS`], [SQL has no direct division operator.],
  [Aggregation in extended RA], [`GROUP BY`, `COUNT`, `AVG`, `MIN`, `MAX`, `SUM`], [Basic RA from the slides does not express grouping or averages.],
)

= Query Design Method

#table(
  columns: (0.55fr, 5.7fr),
  table.header(h[Step], h[Action]),
  [1], [Underline the requested output. If the question asks for titles and authors, the final `SELECT` should contain only those attributes unless extra attributes are explicitly requested.],
  [2], [List the tables needed to connect the output to the condition. If the condition mentions reader names and the output is book data, the path is `READER -> WISHLIST -> BOOK`.],
  [3], [Write explicit joins. Prefer `JOIN ... ON` when attribute names differ or ambiguity is possible. `USING` is fine when the shared attribute name is exactly the intended join key.],
  [4], [Add row filters in `WHERE`. These are predicates that apply before aggregation.],
  [5], [If the question asks for "number", "average", "highest average", "more than once", or "for each", decide the grouping key and write `GROUP BY`.],
  [6], [If the question asks for absence, use `EXCEPT`, `NOT EXISTS`, or `LEFT JOIN ... IS NULL`. Avoid `NOT IN` when the subquery could contain `NULL`.],
  [7], [If the question asks for "all", use division logic: compare counts of distinct required items, or use double `NOT EXISTS`.],
  [8], [Check duplicates. Add `DISTINCT` only when the selected attributes can repeat and the expected answer is a set.],
)

= Core Templates

#table(
  columns: (1.45fr, 4.9fr),
  table.header(h[Problem type], h[Template]),
  [Simple join], [```sql
SELECT DISTINCT wanted_columns
FROM A
JOIN B ON A.key = B.key
WHERE row_condition;
```],
  [Grouped count], [```sql
SELECT group_attribute, COUNT(*) AS n
FROM R
WHERE row_condition
GROUP BY group_attribute
HAVING COUNT(*) > threshold;
```],
  [Count distinct values], [```sql
SELECT group_attribute, COUNT(DISTINCT value_attribute) AS n
FROM R
GROUP BY group_attribute;
```],
  [Maximum aggregate with ties], [```sql
WITH Scores AS (
  SELECT x, AVG(y) AS avg_y
  FROM R
  GROUP BY x
), MaxScore AS (
  SELECT MAX(avg_y) AS max_avg_y
  FROM Scores
)
SELECT x
FROM Scores JOIN MaxScore ON avg_y = max_avg_y;
```],
  [Absence with set difference], [```sql
SELECT key FROM Candidate
EXCEPT
SELECT key FROM Bad;
-- Oracle uses MINUS instead of EXCEPT.
```],
  [Absence with `NOT EXISTS`], [```sql
SELECT c.key
FROM Candidate c
WHERE NOT EXISTS (
  SELECT 1
  FROM Bad b
  WHERE b.key = c.key
);
```],
  [Include rows with no match], [```sql
SELECT a.key, b.value
FROM A a
LEFT JOIN B b ON b.key = a.key;
```],
  [Find rows with no match], [```sql
SELECT a.key
FROM A a
LEFT JOIN B b ON b.key = a.key
WHERE b.key IS NULL;
```],
  [Self-join for pairs], [```sql
SELECT DISTINCT r1.target
FROM R r1
JOIN R r2 ON r1.target = r2.target
          AND r1.witness < r2.witness;
```],
  [All required items by counting], [```sql
WITH Required AS (
  SELECT DISTINCT item FROM S
), Have AS (
  SELECT candidate, COUNT(DISTINCT item) AS n
  FROM R
  WHERE item IN (SELECT item FROM Required)
  GROUP BY candidate
), Need AS (
  SELECT COUNT(*) AS n FROM Required
)
SELECT candidate
FROM Have JOIN Need USING (n);
```],
)

= Duplicates And `DISTINCT`

SQL duplicates are the biggest difference from relational algebra. The exam explicitly asks you to mark when `DISTINCT` is needed.

#table(
  columns: (2.05fr, 4.25fr),
  table.header(h[Case], h[Decision]),
  [Selecting a primary key from its own table], [`DISTINCT` is usually unnecessary because the key is already unique.],
  [Selecting non-key attributes after a join], [`DISTINCT` is often needed, because several joined rows may project to the same visible result.],
  [Selecting titles and authors instead of ISBNs], [`DISTINCT` may be needed because different ISBNs can share the same title and author.],
  [Using `GROUP BY` on exactly the output attributes], [`DISTINCT` is unnecessary because grouping already creates one row per group.],
  [Using `UNION`, `INTERSECT`, `EXCEPT`, or `MINUS`], [`DISTINCT` is unnecessary for the set operator result because duplicates are removed by default.],
  [Using `UNION ALL`], [Duplicates are intentionally kept. Do not use it unless multiplicities matter.],
)

= Aggregation Rules

#table(
  columns: (1.55fr, 4.75fr),
  table.header(h[Rule], h[Consequence]),
  [`COUNT(*)`], [Counts rows, including rows where some attributes are `NULL`.],
  [`COUNT(A)`], [Counts non-`NULL` values of `A`.],
  [`COUNT(DISTINCT A)`], [Counts different non-`NULL` values of `A`. Use this for "number of authors" if an author can have several books.],
  [`AVG`, `SUM`, `MIN`, `MAX`], [Ignore `NULL` values. If all values are `NULL`, the result is `NULL`.],
  [`WHERE` before `GROUP BY`], [Filters rows before aggregation. Example: keep only ratings of books from one author.],
  [`HAVING` after `GROUP BY`], [Filters groups after aggregation. Example: keep books with `COUNT(*) > 1`.],
  [Non-aggregate in `SELECT`], [Must appear in `GROUP BY`. If you select `Year, Author, COUNT(*)`, then group by `Year, Author`.],
  [Joining before counting], [A join may multiply rows. Use `COUNT(DISTINCT ...)` when counting entities rather than joined rows.],
)

= Absence, Negation, And `NULL`

#table(
  columns: (1.65fr, 4.65fr),
  table.header(h[Trap], h[Safe method]),
  [`NOT IN` with possible `NULL`], [Avoid it. If the subquery contains `NULL`, SQL three-valued logic can make the result empty or surprising. Use `NOT EXISTS` instead.],
  [Using `<>` to find things that do not exist], [Wrong for absence. Inequality joins compare existing pairs; they do not prove that no matching row exists. Use `EXCEPT` or `NOT EXISTS`.],
  [Filtering right table after `LEFT JOIN`], [A predicate on the right table in `WHERE` can turn the outer join into an inner join. Put match conditions in `ON`; put `right.key IS NULL` in `WHERE` only when looking for missing matches.],
  [`NULL = NULL`], [This is unknown, not true. Use `IS NULL` or `IS NOT NULL`.],
)

= Join Choices

#table(
  columns: (1.4fr, 4.9fr),
  table.header(h[Join form], h[Use]),
  [`JOIN ... ON`], [Best default. It is explicit, handles different attribute names, and avoids accidental joins on same-name attributes.],
  [`JOIN ... USING (A)`], [Good when both tables have the same join column name and that is exactly the intended equality condition.],
  [`NATURAL JOIN`], [Avoid in exams unless explicitly requested. It joins on all same-name attributes, which can silently change if schemas change.],
  [`CROSS JOIN`], [Use only when the Cartesian product is intended, such as constructing all candidate-required pairs for division logic.],
  [`LEFT JOIN`], [Use when rows from the left table must appear even if there is no matching right row.],
  [Self-join], [Use aliases such as `R r1` and `R r2`. Add an anti-symmetry condition like `r1.id < r2.id` when unordered pairs are enough.],
)

= Exam Exercise 3: Subject

Database schema:

```text
READER(RId, Name, YoB)
BOOK(ISBN, Title, Author, Year)
WISHLIST(RId, ISBN)
RATING(RId, ISBN, Rating)
```

The intended meanings are: `READER` stores reader identifiers, names, and years of birth; `BOOK` stores books identified by ISBN; `WISHLIST` stores which reader has which book in their wishlist; `RATING` stores ratings from 1 to 5. Only one rating per reader and per book is allowed.

Queries to write in SQL syntax, and where possible in relational algebra, using as few subqueries as possible and clearly marking when `DISTINCT` is needed:

#table(
  columns: (0.35fr, 5.9fr),
  table.header(h[Part], h[Request]),
  [a], [The book titles and authors in the wishlist of the reader named `Peter`.],
  [b], [The books, by ISBN, that have been added to a wishlist but never rated.],
  [c], [The books, by title and author, that have been rated more than once.],
  [d], [The names of authors having the highest average rating.],
  [e], [The names of authors which have had none of their books rated.],
  [f], [List the number of authors for each year, for years in which at least one author has published a book.],
)

= Exercise 3: Solutions

== a) Titles and authors in Peter's wishlist

```sql
SELECT DISTINCT b.Title, b.Author
FROM READER r
JOIN WISHLIST w ON w.RId = r.RId
JOIN BOOK b ON b.ISBN = w.ISBN
WHERE r.Name = 'Peter';
```

`DISTINCT` is needed because `Name` is not declared as a key, so there may be several readers named Peter, and because different ISBNs can project to the same `(Title, Author)` pair.

Relational algebra:

```text
(READER:Name='Peter' * WISHLIST * BOOK)[Title, Author]
```

If using theta joins instead of natural joins, explicitly join `READER.RId = WISHLIST.RId` and `WISHLIST.ISBN = BOOK.ISBN`.

== b) ISBNs in a wishlist but never rated

```sql
SELECT ISBN
FROM WISHLIST
EXCEPT
SELECT ISBN
FROM RATING;
```

Use `MINUS` instead of `EXCEPT` in Oracle-style SQL. `DISTINCT` is not needed because `EXCEPT` and `MINUS` return a set.

Alternative without set difference:

```sql
SELECT DISTINCT w.ISBN
FROM WISHLIST w
WHERE NOT EXISTS (
  SELECT 1
  FROM RATING r
  WHERE r.ISBN = w.ISBN
);
```

Relational algebra:

```text
WISHLIST[ISBN] - RATING[ISBN]
```

== c) Books rated more than once

```sql
SELECT DISTINCT b.Title, b.Author
FROM BOOK b
JOIN RATING r1 ON r1.ISBN = b.ISBN
JOIN RATING r2 ON r2.ISBN = r1.ISBN
              AND r1.RId < r2.RId;
```

The self-join finds two different readers who rated the same ISBN. The condition `r1.RId < r2.RId` avoids symmetric duplicate pairs. `DISTINCT` is still needed because a book with many ratings creates several pairs, and because several ISBNs may share the same title and author.

Equivalent grouped solution:

```sql
WITH RatedMoreThanOnce AS (
  SELECT ISBN
  FROM RATING
  GROUP BY ISBN
  HAVING COUNT(*) > 1
)
SELECT DISTINCT b.Title, b.Author
FROM BOOK b
JOIN RatedMoreThanOnce r ON r.ISBN = b.ISBN;
```

Relational algebra:

```text
R1(r1, isbn1, rating1) <- RATING[RId, ISBN, Rating]
R2(r2, isbn2, rating2) <- RATING[RId, ISBN, Rating]
ManyISBN(isbn) <- (R1(R1.isbn1 = R2.isbn2 and R1.r1 <> R2.r2)*R2)[isbn1]
Result <- (ManyISBN * BOOK)[Title, Author]
```

== d) Authors with the highest average rating

```sql
WITH AuthorAverage AS (
  SELECT b.Author, AVG(r.Rating) AS avg_rating
  FROM BOOK b
  JOIN RATING r ON r.ISBN = b.ISBN
  GROUP BY b.Author
), MaxAverage AS (
  SELECT MAX(avg_rating) AS max_avg_rating
  FROM AuthorAverage
)
SELECT Author
FROM AuthorAverage
JOIN MaxAverage ON avg_rating = max_avg_rating;
```

`DISTINCT` is not needed because `AuthorAverage` has one row per author. Ties are preserved because every author whose average equals the maximum is returned. Authors with no ratings are not candidates for highest average rating because they have no average rating.

Basic relational algebra from the slides cannot express this query because it requires `AVG`, `GROUP BY`, and `MAX`.

== e) Authors with none of their books rated

```sql
SELECT Author
FROM BOOK
EXCEPT
SELECT b.Author
FROM BOOK b
JOIN RATING r ON r.ISBN = b.ISBN;
```

Use `MINUS` instead of `EXCEPT` in Oracle-style SQL. `DISTINCT` is not needed because the set operator removes duplicates.

Alternative with `NOT EXISTS`:

```sql
SELECT DISTINCT b.Author
FROM BOOK b
WHERE NOT EXISTS (
  SELECT 1
  FROM BOOK b2
  JOIN RATING r ON r.ISBN = b2.ISBN
  WHERE b2.Author = b.Author
);
```

Relational algebra:

```text
BOOK[Author] - (BOOK * RATING)[Author]
```

== f) Number of authors for each publication year

```sql
SELECT Year, COUNT(DISTINCT Author) AS author_count
FROM BOOK
GROUP BY Year;
```

`COUNT(DISTINCT Author)` is needed because the same author can publish several books in the same year. No `HAVING` clause is needed: grouping over `BOOK` already lists only years in which at least one book exists. Basic relational algebra from the slides cannot express this query because it requires grouping and counting.

= Final Exam Checklist

#table(
  columns: (1.65fr, 4.65fr),
  table.header(h[Before submitting], h[Check]),
  [Output columns], [They exactly match the requested attributes. Extra IDs are not shown unless asked.],
  [Join path], [Every table is connected by a meaningful key equality. No accidental Cartesian product remains.],
  [Duplicates], [`DISTINCT` is present only when projection can duplicate visible rows.],
  [Absence], [Uses `EXCEPT`, `MINUS`, `NOT EXISTS`, or `LEFT JOIN ... IS NULL`, not an inequality join.],
  [Aggregates], [Every non-aggregate selected expression is in `GROUP BY`; aggregate filters use `HAVING`.],
  [Counts], [Uses `COUNT(DISTINCT ...)` when counting entities rather than rows.],
  [Ties], [Maximum or minimum queries return all tied answers unless the question says only one.],
  [Relational algebra], [Provided only where basic RA can express the query; aggregation queries are marked as requiring extended RA or SQL.],
)
