CREATE VIEW [adf].[GetAllJobParametersJSON]

AS

WITH    AllParameters

AS      (
            SELECT   [Jobs].[JobId]
                    ,[Projects].[ProjectParameterName] AS ParameterName
                    ,[Projects].[ProjectParameterValue] AS ParameterValue
                    ,2 AS OrderValue

            FROM    [adf].[Jobs] AS Jobs

            LEFT JOIN [adf].[JobParameters] AS JobParameters
                ON [Jobs].[JobId] = [JobParameters].[JobId]

			LEFT JOIN [adf].[Flows] AS Flows
				ON [Jobs].[FlowId] = [Flows].[FlowId]

            INNER JOIN [adf].[ProjectParameters] AS Projects
                ON [Jobs].[JobType] = [Projects].[ProjectParameterJobType] 
				AND 
				   [Flows].[ProjectId] = [Projects].[ProjectId] 

            UNION 

            SELECT   [JobParameters2].[JobId]
                    ,[JobParameters2].[JobParameterName] AS ParameterName
                    ,[JobParameters2].[JobParameterValue] AS ParameterValue
                    ,1 AS OrderValue
            FROM [adf].[JobParameters] AS JobParameters2
        ),

        AllParametersWithDuplicateCount
         
AS      (

            SELECT   [JobId] 
                    ,[ParameterName]
                    ,[ParameterValue]
                    ,ROW_NUMBER() OVER( PARTITION BY    [JobId], 
                                                        [ParameterName] 
                                        ORDER BY        [OrderValue] ASC) 
                                  AS    DuplicateCount
            
            FROM    [AllParameters]
        )

 SELECT     [JobId],
            '{' + 
            STRING_AGG  (   '"' + 
                                [ParameterName] + 
                                '": "' + 
                                [ParameterValue] + 
                                '"' ,
                                ','
                            ) 
            + '}' AS JobParameters
 
 FROM       [AllParametersWithDuplicateCount]
 
 WHERE      [DuplicateCount] = 1
 
 GROUP BY   [JobId]