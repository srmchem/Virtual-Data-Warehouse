SET NOCOUNT ON;

DECLARE @source_database varchar(100), @source_schema varchar(100),
                                @table_type varchar(100), @table_name varchar(100), @column_name varchar(100), 
                                @datatype varchar(100), @char_max_lengh int, @num_precision int,
                                @num_scale int, @streamlined_datatype varchar(100), @streamlined_columns varchar(max),
                                @key_column varchar(100), @key_column_concat varchar(max), @record_source varchar(100);
                                
SET @table_type = 'HSTG'
SET @record_source ='PROFILER'
SET @source_database = 'EDW_000_Source_Database'
SET @source_schema = 'dbo'                     

DECLARE table_cursor CURSOR FOR 
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_CATALOG = @source_database AND TABLE_SCHEMA = @source_schema;

OPEN table_cursor

FETCH NEXT FROM table_cursor INTO @table_name

WHILE @@FETCH_STATUS = 0

BEGIN
                
                SET @streamlined_columns = '';
                SET @key_column_concat = '';

                DECLARE column_cursor CURSOR FOR
                SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, NUMERIC_PRECISION, NUMERIC_SCALE  FROM INFORMATION_SCHEMA.COLUMNS 
                WHERE TABLE_CATALOG = @source_database AND TABLE_SCHEMA = @source_schema AND TABLE_NAME = @table_name
                ORDER BY ORDINAL_POSITION;
                
                OPEN column_cursor
                
                FETCH NEXT FROM column_cursor INTO @column_name, @datatype, @char_max_lengh, @num_precision, @num_scale
                
                WHILE @@FETCH_STATUS = 0
                IF @table_type IN ('STG', 'HSTG')
                                BEGIN
                                                IF @datatype = 'varchar'
                                                                IF @char_max_lengh <= 100
                                                                                BEGIN SET @streamlined_datatype = 'varchar(100)' END
                                                                ELSE IF @char_max_lengh > 100 AND @char_max_lengh <= 1000
                                                                                BEGIN SET @streamlined_datatype = 'varchar(1000)' END
                                                                ELSE IF @char_max_lengh > 1000
                                                                                BEGIN SET @streamlined_datatype = 'varchar(4000)' END            
                                                                ELSE SET @streamlined_datatype = 'varchar(STREAMLINING ERROR)'
                                                
                                                ELSE IF @datatype in ('decimal', 'numeric')
                                                                BEGIN SET @streamlined_datatype = 'numeric(38,20)' END                                         
                                                
                                                ELSE IF @datatype in ('int')
                                                                BEGIN SET @streamlined_datatype = 'int' END 

                                                ELSE IF @datatype in ('date','datetime','datetime2')
                                                                BEGIN SET @streamlined_datatype = 'datetime2(7)' END
                                                                
                                                ELSE SET @streamlined_datatype = 'STREAMLINING ERROR'
                                                
                                                SET @streamlined_columns = @streamlined_columns + char(10) + '  ,[' + @column_name + '] ' + @streamlined_datatype
                                                FETCH NEXT FROM column_cursor INTO @column_name, @datatype, @char_max_lengh, @num_precision, @num_scale
                                END

                CLOSE column_cursor;
                DEALLOCATE column_cursor;
                
                DECLARE key_cursor CURSOR FOR
                SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
                WHERE OBJECTPROPERTY(OBJECT_ID(constraint_name), 'IsPrimaryKey') = 1 
                AND CONSTRAINT_CATALOG = @source_database AND CONSTRAINT_SCHEMA = @source_schema AND TABLE_NAME = @table_name
                
                OPEN key_cursor
                FETCH NEXT FROM key_cursor INTO @key_column
                WHILE @@FETCH_STATUS = 0
                BEGIN
                                SET @key_column_concat = @key_column_concat + ',' + @key_column + ' ASC'
                                FETCH NEXT FROM key_cursor INTO @key_column
                END
                CLOSE key_cursor;
                DEALLOCATE key_cursor;
                SET @key_column_concat = STUFF(@key_column_concat,1,1,'')
                

SET @streamlined_columns = SUBSTRING(@streamlined_columns,2,LEN(@streamlined_columns)) --remove newline char

IF @table_type = 'STG'
BEGIN
                PRINT 'CREATE TABLE [STG_' + @record_source + '_' + @table_name + ']'
                PRINT '('
                PRINT '   [ETL_INSERT_RUN_ID] int NOT NULL'
                PRINT '  ,[LOAD_DATETIME] datetime2(7) NOT NULL'
                PRINT '  ,[EVENT_DATETIME] datetime2(7) NOT NULL'
                PRINT '  ,[RECORD_SOURCE] varchar(100) NOT NULL'
                PRINT '  ,[SOURCE_ROW_ID] int NOT NULL IDENTITY(1,1)'
                PRINT '  ,[CDC_OPERATION] varchar(100) NOT NULL'
                PRINT '  ,[HASH_FULL_RECORD] char(32) NOT NULL'
                PRINT @streamlined_columns
                PRINT ');'
				PRINT '';
				PRINT 'ALTER TABLE [dbo].[STG_' + @record_source + '_' + @table_name + '] ADD  DEFAULT (getdate()) FOR [LOAD_DATETIME];';
				PRINT '';

END

IF @table_type = 'HSTG'
BEGIN
                PRINT 'CREATE TABLE [HSTG_' + @record_source + '_' + @table_name + ']'
                PRINT '('
                PRINT '  HSTG_'+@record_source+'_' + @table_name + '_SK int NOT NULL IDENTITY' 
                PRINT '  ,[ETL_INSERT_RUN_ID] int NOT NULL'
                PRINT '  ,[LOAD_DATETIME] datetime2(7) NOT NULL'
                PRINT '  ,[RECORD_SOURCE] varchar(100) NOT NULL'
                PRINT '  ,[SOURCE_ROW_ID] int NOT NULL'
                PRINT '  ,[CDC_OPERATION] varchar(100) NOT NULL'
                PRINT '  ,[HASH_FULL_RECORD] char(32) NOT NULL'
                PRINT @streamlined_columns
                PRINT '  PRIMARY KEY NONCLUSTERED(HSTG_' + @record_source + '_' + @table_name + '_SK ASC)'
                PRINT '  WITH (DATA_COMPRESSION = Page, FILLFACTOR = 90)'
                PRINT ');'
                PRINT ''
                PRINT 'CREATE UNIQUE CLUSTERED INDEX [IX_HSTG_'+@record_source+'_' + @table_name + '] ON ' + '[HSTG_'+@record_source+'_' + @table_name + ']'
                PRINT '(' + @key_column_concat + ',LOAD_DATETIME)  WITH (DATA_COMPRESSION = Page, FILLFACTOR = 90);'
                PRINT ''
END

FETCH NEXT FROM table_cursor 
INTO @table_name


END 

CLOSE table_cursor;
DEALLOCATE table_cursor;
