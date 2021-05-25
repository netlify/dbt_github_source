with

base as (

    select * from {{ source('github', 'repo_team') }}

),

fields as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns
        that are expected/needed (staging_columns from dbt_github_source/models/tmp/) and compares it with columns
        in the source (source_columns from dbt_github_source/macros/).

        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{ fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(source('github', 'repo_team')),
            staging_columns=get_repo_team_columns()
        ) }}
    from base

),

final as (

    select
        repository_id,
        team_id
    from fields

)

select * from final
