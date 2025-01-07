CREATE TABLE [adf].[JobDependencies] (
    [DependingJobId]          NVARCHAR (900) NOT NULL,
    [PrerequisiteJobId]       NVARCHAR (900) NOT NULL,
    [JobDependencyType]       NVARCHAR (MAX) NULL,
    [JobDependecyDescription] NVARCHAR (MAX) NULL
);

