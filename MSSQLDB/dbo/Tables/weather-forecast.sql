CREATE TABLE [dbo].[weather-forecast]
(
	[Id] INT NOT NULL PRIMARY KEY, 
    [date] DATETIME2 NOT NULL, 
    [temperature_celsius] SMALLINT NOT NULL, 
    [summary] NVARCHAR(50) NOT NULL
)
