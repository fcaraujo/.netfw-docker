IF NOT EXISTS(SELECT TOP 1 1 FROM [dbo].[Value])
BEGIN
	INSERT INTO [dbo].[Value] (Content)
	VALUES ('Testing')
END

GO