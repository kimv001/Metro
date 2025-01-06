
CREATE
FUNCTION [rep].[getcolumnlistperdatasetbk] (@datasetbk varchar(255), @option int = 1, @type varchar(7), @prefixa varchar(MAX) = '', @postfixa varchar(MAX) = '', @prefixds varchar(MAX) = '', @postfixds varchar(MAX) = '', @seperator varchar(MAX) = '', @useexpression int = 0) RETURNS varchar(MAX) AS BEGIN -- Declare the return variable here
 DECLARE @result varchar(MAX),

       @lenseperator int = len(@seperator)-0 IF @option = -1 -- column cast as datatype ordered by ordinal position

SELECT @result = @prefixds + stuff(
                                     (SELECT @seperator + char(10) + isnull(@prefixa + isnull(CASE
                                                                                                  WHEN @useexpression = 1 THEN isnull(cast(a.expression AS varchar(MAX)), quotename(a.attributename))
                                                                                                  WHEN @useexpression = 0 THEN quotename(a.attributename)
                                                                                              END , '') +@ postfixa, 'N/A')
                                      FROM bld.vw_attribute a
                                      WHERE 1 = 1
                                        AND a.bk_dataset = @datasetbk
                                        AND ((iif(@type = '', 'all', @type) = 'all')
                                             OR (@type = 'bk_data'
                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                             OR (@type = 'bk'
                                                 AND cast(a.businesskey AS int) > 0)
                                             OR (@type = 'data'
                                                 AND cast(a.businesskey AS int) = 0
                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                             OR (@type = 'rh'
                                                 AND cast(a.businesskey AS int) = 0
                                                 AND isnull(a.ismta, 0) = 0
                                                 AND cast(isnull(a.notinrh, 0) AS int) = 0)
                                             OR (@type = 'mta'
                                                 AND cast(isnull(a.ismta, 0) AS int) = 1))
                                      ORDER BY CASE
                                                   WHEN @type = 'bk' THEN cast(a.businesskey AS int)
                                                   ELSE cast(a.ordinalposition AS int)
                                               END ASC
                                      FOR XML path(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, @lenseperator, '') + @postfixds IF @option = -2 -- column cast as datatype ordered by ordinal position

SELECT @result = @prefixds + stuff(
                                     (SELECT @seperator + char(10) + isnull(@prefixa + quotename(a.attributename) + ' ' + a.[ddl_type2] +@ postfixa, 'N/A')
                                      FROM bld.vw_attribute a
                                      WHERE 1 = 1
                                        AND a.bk_dataset = @datasetbk
                                        AND ((iif(@type = '', 'all', @type) = 'all')
                                             OR (@type = 'bk_data'
                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                             OR (@type = 'bk'
                                                 AND a.businesskey IS NOT NULL)
                                             OR (@type = 'data'
                                                 AND a.businesskey IS NULL
                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                             OR (@type = 'rh'
                                                 AND a.businesskey IS NULL
                                                 AND cast(isnull(a.ismta, 0) AS int) = 0
                                                 AND cast(isnull(a.notinrh, 0) AS int) = 0)
                                             OR (@type = 'mta'
                                                 AND cast(isnull(a.ismta, 0) AS int) = 1))
                                      ORDER BY CASE
                                                   WHEN @type = 'bk' THEN cast(a.businesskey AS int)
                                                   ELSE cast(a.ordinalposition AS int)
                                               END ASC
                                      FOR XML path(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, @lenseperator, '') + @postfixds IF @option = -4 -- column cast as datatype ordered by ordinal position

SELECT @result = @prefixds + stuff(
                                     (SELECT @seperator + char(10) + isnull(@prefixa + isnull(cast(a.expression AS varchar(MAX)), quotename(a.attributename)) + ' ' + a.[ddl_type3] +@ postfixa + ' ' + quotename(cast(a.attributename AS varchar(MAX))), 'N/A')
                                      FROM bld.vw_attribute a
                                      WHERE 1 = 1
                                        AND a.bk_dataset = @datasetbk
                                        AND ((iif(@type = '', 'all', @type) = 'all')
                                             OR (@type = 'bk_data'
                                                 AND isnull(a.ismta, 0) = 0)
                                             OR (@type = 'bk'
                                                 AND cast(a.businesskey AS int) > 0)
                                             OR (@type = 'data'
                                                 AND cast(a.businesskey AS int) = 0
                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                             OR (@type = 'rh'
                                                 AND cast(a.businesskey AS int) = 0
                                                 AND cast(isnull(a.ismta, 0) AS int) = 0
                                                 AND cast(isnull(a.notinrh, 0) AS int) = 0)
                                             OR (@type = 'mta'
                                                 AND cast(isnull(a.ismta, 0) AS int) = 1))
                                      ORDER BY CASE
                                                   WHEN @type = 'bk' THEN (isnull(cast(a.businesskey AS int), 100) * 1000) + cast(a.ordinalposition AS int)
                                                   ELSE cast(a.ordinalposition AS int)
                                               END ASC
                                      FOR XML path(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, @lenseperator, '') + @postfixds IF @option = -7 --- Empty Dummies

SELECT @result = replace(replace(@prefixds + stuff(
                                                     (SELECT @seperator + isnull(@prefixa + [rep].[getdummyvaluebyattributebk](a.bk, '-1', '<Empty>', '1900-01-01') + ' AS ' + quotename(a.attributename) +@ postfixa, '')
                                                      FROM bld.vw_attribute a
                                                      WHERE 1 = 1
                                                        AND a.bk_dataset = @datasetbk
                                                        AND ((iif(@type = '', 'all', @type) = 'all')
                                                             OR (@type = 'bk_data'
                                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                                             OR (@type = 'bk'
                                                                 AND a.businesskey IS NOT NULL)
                                                             OR (@type = 'data'
                                                                 AND a.businesskey IS NULL
                                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                                             OR (@type = 'rh'
                                                                 AND a.businesskey IS NULL
                                                                 AND cast(isnull(a.ismta, 0) AS int) = 0
                                                                 AND cast(a.notinrh AS int) = 0)
                                                             OR (@type = 'mta'
                                                                 AND cast(isnull(a.ismta, 0) AS int) = 1))
                                                      ORDER BY CASE
                                                                   WHEN @type = 'bk' THEN (isnull(cast(a.businesskey AS int), 100) * 1000) + cast(a.ordinalposition AS int)
                                                                   ELSE cast(a.ordinalposition AS int)
                                                               END ASC
                                                      FOR XML path(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, @lenseperator, '') + @postfixds , '&lt;', '<'), '&gt;', '>') IF @option = -8 --- Empty Unknown

SELECT @result = replace(replace(@prefixds + stuff(
                                                     (SELECT @seperator + isnull(@prefixa + [rep].[getdummyvaluebyattributebk](a.bk, '-2', '<Unknown>', '1900-01-01') + ' AS ' + quotename(a.attributename) +@ postfixa, '')
                                                      FROM bld.vw_attribute a
                                                      WHERE 1 = 1
                                                        AND a.bk_dataset = @datasetbk
                                                        AND ((iif(@type = '', 'all', @type) = 'all')
                                                             OR (@type = 'bk_data'
                                                                 AND isnull(a.ismta, 0) = 0)
                                                             OR (@type = 'bk'
                                                                 AND a.businesskey IS NOT NULL)
                                                             OR (@type = 'data'
                                                                 AND a.businesskey IS NULL
                                                                 AND cast(isnull(a.ismta, 0) AS int) = 0)
                                                             OR (@type = 'rh'
                                                                 AND a.businesskey IS NULL
                                                                 AND cast(isnull(a.ismta, 0) AS int) = 0
                                                                 AND cast(a.notinrh AS int) = 0)
                                                             OR (@type = 'mta'
                                                                 AND cast(isnull(a.ismta, 0) AS int) = 1))
                                                      ORDER BY CASE
                                                                   WHEN @type = 'bk' THEN (isnull(cast(a.businesskey AS int), 100) * 1000) + cast(a.ordinalposition AS int)
                                                                   ELSE cast(a.ordinalposition AS int)
                                                               END ASC
                                                      FOR XML path(''), TYPE).value('.', 'VARCHAR(MAX)'), 1, @lenseperator, '') + @postfixds , '&lt;', '<'), '&gt;', '>') -- Return the result of the function
 RETURN @result END
