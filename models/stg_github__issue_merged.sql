{{ config(alias='stg_github_issue_merged') }}
with issue_merged as (

    select *
    from {{ var('issue_merged') }}

), macro as (
    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns
        that are expected/needed (staging_columns from dbt_github_source/models/tmp/) and compares it with columns
        in the source (source_columns from dbt_github_source/macros/).

        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('issue_merged')),
                staging_columns=get_issue_merged_columns()
            )
        }}

    from issue_merged

), fields as (

    select
      issue_id,
      merged_at

    from macro
)

select *
from fields
