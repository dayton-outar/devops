

SELECT  t.sp_name ,
        SUM(t.lines_of_code) - 1 AS lines_of_code ,
        t.type_desc
FROM    ( SELECT    o.name AS sp_name ,
                    ( LEN(c.text) - LEN(REPLACE(c.text, CHAR(10), '')) ) AS lines_of_code ,
                    CASE WHEN o.xtype = 'P' THEN 'Stored Procedure'
                         WHEN o.xtype IN ( 'FN', 'IF', 'TF' ) THEN 'Function'
                    END AS type_desc
          FROM      sysobjects o
                    INNER JOIN syscomments c ON c.id = o.id
          WHERE     o.xtype IN ( 'P', 'FN', 'IF', 'TF' )
                    AND c.text LIKE '%SQL2K8CLUSTER%'
                    AND o.category = 0
                    AND o.name NOT IN ( 'fn_diagramobjects', 'sp_alterdiagram',
                                        'sp_creatediagram', 'sp_dropdiagram',
                                        'sp_helpdiagramdefinition',
                                        'sp_helpdiagrams', 'sp_renamediagram',
                                        'sp_upgraddiagrams', 'sysdiagrams' )
        ) t
GROUP BY t.sp_name ,
        t.type_desc
ORDER BY 1;