
DECLARE @begin DATE = '2017-07-31';
DECLARE @end DATE = '2017-09-01';

CREATE TABLE #Person
    (
      [Person] UNIQUEIDENTIFIER NOT NULL ,
      [Logged] DATE NOT NULL ,
      [DayOfWeek] CHAR(1) NOT NULL
    );

;
WITH    generatedDates
          AS ( SELECT   @begin AS [Logged] ,
                        1 AS [Level]
               UNION ALL
               SELECT   DATEADD(DAY, 1, [Logged]) ,
                        [Level] + 1
               FROM     generatedDates
               WHERE    [Logged] < @end
             )
    INSERT  INTO [#Person]
            ( [Person] ,
              [Logged] ,
              [DayOfWeek]
            )
            SELECT  R.[Person] ,
                    G.[Logged] ,
                    R.[DayOfWeek]
            FROM    generatedDates G
                    INNER JOIN [dbo].[PersonWorkRoster] R ON CAST(R.[DayOfWeek] AS INT) = ( DATEPART(dw,
                                                              [Logged]) - 1 )
            ORDER BY [Logged] ASC
    OPTION  ( MAXRECURSION 12000 );


		INSERT  INTO [dbo].[PersonRegister]
        ( [Person] ,
          [Logged] ,
          [Code] ,
          [Late]
        )
        SELECT  X.[Person] ,
                X.[Logged] ,
                'A' [Code] ,
                0 AS [Late]
        FROM    [#Person] X
                LEFT OUTER JOIN ( SELECT    L.[NortelUserID] [Person] ,
                                            CAST(L.[Logged] AS DATE) [Logged]
                                  FROM      [dbo].[PersonLoginStats] L
                                  GROUP BY  [L].[NortelUserID] ,
                                            CAST(L.[Logged] AS DATE)
                                ) V ON [V].[Person] = [X].[Person]
                                       AND [V].[Logged] = [X].[Logged]
        WHERE   NOT EXISTS ( SELECT ''
                             FROM   [dbo].[PersonRegister] R
                             WHERE  R.[Person] = X.[Person]
                                    AND R.[Logged] = CAST(X.[Logged] AS DATE) )
                AND V.[Logged] IS NULL
        UNION
        SELECT  X.[NortelUserID] [Person] ,
                X.[Logged] ,
                'L' [Code] ,
                MAX(CASE WHEN R.[Start] < X.[Started]
                         THEN DATEDIFF(s, R.[Start], X.[Started])
                         ELSE 0
                    END) [Late]
        FROM    ( SELECT    L.[NortelUserID] ,
                            CAST(L.[Logged] AS DATE) [Logged] ,
                            CONVERT(TIME(0), MIN(L.[Logged])) [Started] ,
                            CONVERT(TIME(0), MAX(L.[Logged])) [Finished]
                  FROM      [dbo].[PersonLoginStats] L
                  GROUP BY  CAST(L.[Logged] AS DATE) ,
                            L.[NortelUserID]
                ) X
                INNER JOIN [dbo].[PersonWorkRoster] R ON R.[Person] = X.[NortelUserID]
                                                         AND CAST(R.[DayOfWeek] AS INT) = DATEPART(dw,
                                                              X.[Logged]) - 1
                INNER JOIN [dbo].[Person] P ON P.[NortelUserID] = X.[NortelUserID]
        WHERE   ( X.[Logged] BETWEEN @begin AND @end )
                AND DATEDIFF(s, R.[Start], X.[Started]) > 0
                AND NOT EXISTS ( SELECT ''
                                 FROM   [dbo].[PersonRegister] R
                                 WHERE  R.[Person] = X.[NortelUserID]
                                        AND R.[Logged] = CAST(X.[Logged] AS DATE) )
        GROUP BY X.[NortelUserID] ,
                R.[DayOfWeek] ,
                X.[Logged]
        ORDER BY X.[Logged];

DROP TABLE [#Person];
GO