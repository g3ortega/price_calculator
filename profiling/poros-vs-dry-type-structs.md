Measuring impact of implementing `dry-types` vs using POROs for entities.

The goal is to ensure the integrity of the data handled by entities, and eventually create custom rules as needed.

```
Rehearsal ---------------------------------------------------------------------------------
PORO create and access with keyword arguments   2.110002   0.000000   2.110002 (  2.110184)
dry-type + dry-struct create and access         3.750623   0.000000   3.750623 (  3.750773)
------------------------------------------------------------------------ total: 5.860625sec

                                                    user     system      total        real
PORO create and access with keyword arguments   2.127799   0.000000   2.127799 (  2.127966)
dry-type + dry-struct create and access         3.758408   0.000000   3.758408 (  3.758523)
```

POROs are about 0.56x faster than `dry-type` structs, in exchange we gain a type checking and the possibility of adding business rules with ease.