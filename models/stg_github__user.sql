{{ config(alias='stg_github_user') }}

with

github_user as (

    select * from {{ var('user') }}

),

macro as (

    select
        /*
        The below macro is used to generate the correct SQL for package staging models. It takes a list of columns
        that are expected/needed (staging_columns from dbt_github_source/models/tmp/) and compares it with columns
        in the source (source_columns from dbt_github_source/macros/).

        For more information refer to our dbt_fivetran_utils documentation (https://github.com/fivetran/dbt_fivetran_utils.git).
        */
        {{ fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(var('user')),
            staging_columns=get_user_columns()
        ) }}
    from github_user

),

fields as (

    select
        id as user_id,
        login as login_name,
        "TYPE" as user_type,
        site_admin,
        name as user_name,
        company,
        blog,
        location,
        hireable,
        bio,
        created_at,
        updated_at
    from macro

)

select * from fields
