---
title: 'SQL Azure Gotchas, #27: MAXDOP and the query optimizer'
date: '2014-09-11 17:33:59'
tags:
- SQL Server
- SQL Azure
- Performance
category: Databases
excerpt: >-
    Some investigation uncovers that SQL Azure has some significant differences
    from on-premises SQL Server, which can impact performance in unexpected ways.
---

### Background

I was working with a coworker to port some old code recently to work smarter and
simpler, when I noticed that some new database queries that I had written were
fast locally, but ran 3-5x slower in SQL Azure.

We checked the database load at first, expecting that it was heavily overloaded,
but found that it wasn't an issue. Our next guess was hardware differences, but
I found that the same queries weren't much slower in a VM on my laptop or on my
coworker's laptop than they were on my powerful desktop.

With those two ruled out, it was time to go to the `EXPLAIN` plan. Initially, we
didn't think that was going to prove useful because we expected the difference
to be hardware/load--it turned out that we were totally wrong.

Here's what our query looked like (table and column names are changed to protect
the ~~guilty~~ innocent):

```sql
SELECT DISTINCT *
FROM TableA a
JOIN TableB b ON b.Id = a.BId
LEFT JOIN TableB b2 ON b2.Id = a.OtherBId
JOIN TableC c ON c.Id = l.CId
LEFT JOIN TableC c2 ON c2.OtherId = l.COtherId
WHERE <LIKE CLAUSES HERE>
OPTION (LOOP JOIN);
```

The `LIKE` clauses at the end were searching over `TableB` via `b` and `b2`, and
were as few as 1, and as many as 3 (each with two `LIKE`s joined by an `OR`).

### SQL Azure and Parallel Queries

Once we compared `EXPLAIN` plans from both SQL Server 2012/2014 (these had some
minor, but inconsequential, differences) and SQL Azure, the reason was clear.
The bare metal SQL Server plan had a single index scan to process the `LIKE`
operators, and was followed by nested loops to resolve joins into `TableB` and
`TableC`. Here's what that looked like (this plan comes from SSMS running
against a local server--real table names are blacked out):

[![](/content/images/2014/Sep/sql-server.png)](https://dl.dropboxusercontent.com/u/66703527/sql-server.png)

There's parallelism at every step of the query (the yellow double-arrow marks),
and only at the end are the streams gathered and sorted (the "Gather Streams"
operator right before sorting for DISTINCT).

Here's the same query, with the plan from SQL Azure (using the SQL Azure
management Silverlight console, which produces nicer query plan images):

[![](/content/images/2014/Sep/loop-plan.png)](https://dl.dropboxusercontent.com/u/66703527/loop-plan.png)

The plan looks almost exactly the same, except there's no parallelism. We'd
found our culprit.

### Postmortem/Explanation

Normally, on SQL Server, query parallelism is controlled by the `MAXDOP`
(maximum degrees of parallelism) setting, which you can either configure
globally or on a per-query basis as a query hint (where we wrote `OPTION (LOOP
JOIN)` above, we'd write something like `OPTION (LOOP JOIN, MAXDOP = 5)`).
Usually it's set to `0`, which means "use all the CPUs available".

On SQL Azure, the setting is permanently set to 1, which means no parallelism at
all (only 1 operation at any given time)--this is documented
on
[Microsoft's documentation page for T-SQL statements/query hints on SQL Azure](http://msdn.microsoft.com/en-us/library/azure/ee336270.aspx).
None of us had seen this bit of documentation before, so it came as a bit of a
surprise.

We ended up using the query in production anyway--it was still faster than what
we had by a significant margin, even if it was 3-4x slower than running on
full-fledged SQL Server. We also learned to make sure to test new queries more
thoroughly on the target environment, not just for correctness, but also for
performance, as it appears that SQL Azure's restrictions can, and do, affect it
in subtle and not-so-subtle ways.
