{{ config(alias='stg_github_pull_request_review') }}
with pull_request_review as (

    select *
    from {{ var('pull_request_review') }}

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
                source_columns=adapter.get_columns_in_relation(var('pull_request_review')),
                staging_columns=get_pull_request_review_columns()
            )
        }}

    from pull_request_review

), fields as (

    select
      id as pull_request_review_id,
      pull_request_id,
      submitted_at,
      state,
      user_id

    from macro
)

select *
from fields
