/********************************************************************
	Filename:	DatabaseOptions.sql					 
	Author:		Omid Afzalalghom							 
	Date:		09/09/15								
	Comments:	Returns database options that are enabled as well as
				some other information such as compatibility level
				and recovery model.
	Revisions:	02/12/15 - Added collate catalog_default.											 
********************************************************************/

SET NOCOUNT ON;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

WITH DB_Options1 
AS(
	SELECT  
		DB_Option
	FROM 
		(
		SELECT 
				  CAST('Collation: '			+ collation_name						collate database_default AS NVARCHAR(128)) collation_name
				 ,CAST('Compatibility: '		+ CAST(compatibility_level AS CHAR(3))	collate database_default AS NVARCHAR(128)) compatibility 		
				 ,CAST('Containment: '			+ containment_desc						collate database_default AS NVARCHAR(128)) containment_desc
				 ,CAST('Delayed Durability: '	+ delayed_durability_desc				collate database_default AS NVARCHAR(128)) delayed_durability_desc	
				 ,CAST('Page Verify: '			+ page_verify_option_desc				collate database_default AS NVARCHAR(128)) page_verify_option_desc
				 ,CAST('Recovery Model: '		+ recovery_model_desc					collate database_default AS NVARCHAR(128)) recovery_model_desc
				 ,CAST('Snapshot Isolation: '	+ snapshot_isolation_state_desc			collate database_default AS NVARCHAR(128)) snapshot_isolation_state_desc	
		FROM sys.databases 
		WHERE database_id = DB_ID()
		) a	
	UNPIVOT
	(
	  DB_Option
	  FOR col IN (
				  collation_name
				 ,compatibility  
				 ,containment_desc
				 ,delayed_durability_desc
				 ,page_verify_option_desc
				 ,recovery_model_desc
				 ,snapshot_isolation_state_desc
				)
	) b
),

DB_Options2
AS(
	SELECT  
		CASE WHEN value = 1 THEN col + ' is enabled'
		END 'DB_Option'
	FROM 
		(
		SELECT 
				 is_ansi_null_default_on
				,is_ansi_nulls_on
				,is_ansi_padding_on
				,is_ansi_warnings_on
				,is_arithabort_on
				,is_auto_close_on
				,is_auto_create_stats_incremental_on
				,is_auto_create_stats_on
				,is_auto_shrink_on
				,is_auto_update_stats_async_on
				,is_auto_update_stats_on
				,is_broker_enabled
				,is_cdc_enabled
				,is_cleanly_shutdown
				,is_concat_null_yields_null_on
				,is_cursor_close_on_commit_on
				,is_date_correlation_on
				,is_db_chaining_on
				,is_distributor
				,is_encrypted
				,is_fulltext_enabled
				,is_honor_broker_priority_on
				,is_in_standby
				,is_local_cursor_default
				,is_master_key_encrypted_by_server
				,is_memory_optimized_elevate_to_snapshot_on
				,is_merge_published
				,is_nested_triggers_on
				,is_numeric_roundabort_on
				,is_parameterization_forced
				,is_published
				,is_query_store_on
				,is_quoted_identifier_on
				,is_read_committed_snapshot_on
				,is_read_only
				,is_recursive_triggers_on
				,is_subscribed
				,is_supplemental_logging_enabled
				,is_sync_with_backup
				,is_transform_noise_words_on
				,is_trustworthy_on
		FROM sys.databases 
		WHERE database_id = DB_ID()
		) a	
	UNPIVOT
	(
	  value
	  FOR col IN (
				 is_ansi_null_default_on
				,is_ansi_nulls_on
				,is_ansi_padding_on
				,is_ansi_warnings_on
				,is_arithabort_on
				,is_auto_close_on
				,is_auto_create_stats_incremental_on
				,is_auto_create_stats_on
				,is_auto_shrink_on
				,is_auto_update_stats_async_on
				,is_auto_update_stats_on
				,is_broker_enabled
				,is_cdc_enabled
				,is_cleanly_shutdown
				,is_concat_null_yields_null_on
				,is_cursor_close_on_commit_on
				,is_date_correlation_on
				,is_db_chaining_on
				,is_distributor
				,is_encrypted
				,is_fulltext_enabled
				,is_honor_broker_priority_on
				,is_in_standby
				,is_local_cursor_default
				,is_master_key_encrypted_by_server
				,is_memory_optimized_elevate_to_snapshot_on
				,is_merge_published
				,is_nested_triggers_on
				,is_numeric_roundabort_on
				,is_parameterization_forced
				,is_published
				,is_query_store_on
				,is_quoted_identifier_on
				,is_read_committed_snapshot_on
				,is_read_only
				,is_recursive_triggers_on
				,is_subscribed
				,is_supplemental_logging_enabled
				,is_sync_with_backup
				,is_transform_noise_words_on
				,is_trustworthy_on
				)
	) b
)
SELECT 
	DB_Option 
FROM DB_Options1 
WHERE DB_Option IS NOT NULL

UNION ALL

SELECT 
	DB_Option collate catalog_default
FROM DB_Options2
WHERE DB_Option IS NOT NULL

UNION ALL 
SELECT 'is_change_tracking_on is enabled' 
FROM sys.change_tracking_databases
WHERE database_id = DB_ID();