
CREATE VIEW adf.vw_jobs AS
SELECT [jobid] = src.[jobid],

       [jobname] = src.[jobname],

       [jobdescription] = src.[jobdescription],

       [flowid] = src.[flowid],

       [jobtype] = src.[jobtype],

       [jobgroup] = src.[jobgroup],

       [joborder] = src.[joborder],

       [lastrunduration] = src.[lastrunduration],

       [lastrunstart] = src.[lastrunstart],

       [lastrunstatus] = src.[lastrunstatus],

       [checkpoint] = src.[checkpoint],

       environment = env.environment

  FROM [adf].[jobs] src

 CROSS JOIN [adf].[vw_sdtap] env
