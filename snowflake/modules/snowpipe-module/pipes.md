# Testing: How to force an error

To test the error notification channel works as expected, you can force an error by deploying a pipe with a normalised set of columns (using `table-definitions.csv`) and create a file in s3 with a different schema, ie contains a header when one was not expected. This should yield a COPY error which can be found with.


```
select *
from "SNOWFLAKE"."ACCOUNT_USAGE"."COPY_HISTORY"
where file_name = 'table-definition.csv';
```
