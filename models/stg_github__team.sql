{{ config(alias='stg_github_team') }}
with base as (

    select *
    from {{ var('team') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns
        that are expected/needed (staging_columns from dbt_github_source/models/tmp/) and compares it with columns
        in the source (source_columns from dbt_github_source/macros/).

        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(var('team')),
                staging_columns=get_team_columns()
            )
        }}

    from base

), final as (

    select
        id as team_id,
        description,
        name,
        parent_id,
        privacy,
        slug
    from fields
)

select *
from final
