view: bg_facts {
  # Or, you could make this view a derived table, like this:
  derived_table: {
    sql: WITH answers AS (SELECT *
      , MIN(answer_id) OVER (PARTITION BY question_id, answer_name, level) as min_answer_id
      FROM
        acs.acs_answers_2015_leaf
        ),
        total_population as
        (SELECT
          SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
          COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS total_population
        FROM `acs_partitioned3.acs_*`  AS data
        LEFT JOIN UNNEST(data.answers) as data_answers
        LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
        INNER JOIN answers ON data.question_id = answers.question_id
                    AND data_answers.key = answers.answer_id
                    AND answers.leaf_node = true
        INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
              AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)
        WHERE (_TABLE_SUFFIX LIKE 'Total_Population') AND (questions.question_universe = 'Total Population') AND (answers.answer_name = 'Total')
        GROUP BY 1),
        housing_units as (
        SELECT
          SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
          COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS housing_units
        FROM `acs_partitioned3.acs_*`  AS data
        LEFT JOIN UNNEST(data.answers) as data_answers
        LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
        INNER JOIN answers ON data.question_id = answers.question_id
                    AND data_answers.key = answers.answer_id
                    AND answers.leaf_node = true
        INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
              AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)

        WHERE (_TABLE_SUFFIX LIKE 'Housing_Units') AND (questions.question_universe = 'Housing Units') AND (answers.answer_name = 'Total')
        GROUP BY 1),
        sex as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM(CASE
              WHEN ARRAY_TO_STRING(answers.parent_answers,':') = 'Female'
              THEN SAFE_CAST(data_answers.value AS FLOAT64)
            END), 0) as female,
            COALESCE(SUM(CASE
              WHEN ARRAY_TO_STRING(answers.parent_answers,':') = 'Male'
              THEN SAFE_CAST(data_answers.value AS FLOAT64)
            END), 0) as male
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)

          WHERE (_TABLE_SUFFIX LIKE 'Sex_By_Age') AND (questions.question_universe = 'Total Population') AND (((ARRAY_TO_STRING(answers.parent_answers,':')) = 'Female' OR (ARRAY_TO_STRING(answers.parent_answers,':')) = 'Male'))
          GROUP BY 1),
          white as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS white_alone_or_in_combo
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)

          WHERE (_TABLE_SUFFIX LIKE 'White_Alone_Or_In_Combination_With_One_Or_More_Other_Races') AND (questions.question_universe = 'White Alone Or In Combination With One Or More Other Races') AND (answers.answer_name = 'Total')
          GROUP BY 1),
          black as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS black_alone_or_in_combo
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)

          WHERE (_TABLE_SUFFIX = 'Black_Or_African_American_Alone_Or_In_Combination_With_One_Or_More_Other_Races') AND (questions.question_universe = 'Black Or African American Alone Or In Combination With One Or More Other Races') AND (answers.answer_name = 'Total')
          GROUP BY 1),
          amind as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS amind_alone_or_in_combo
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)

          WHERE (_TABLE_SUFFIX = 'American_Indian_And_Alaska_Native_Alone_Or_In_Combination_With_One_Or_More_Other_Races') AND (questions.question_universe = 'American Indian And Alaska Native Alone Or In Combination With One Or More Other Races') AND (answers.answer_name = 'Total')
          GROUP BY 1),
          asian as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS asian_alone_or_in_combo
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)

          WHERE (_TABLE_SUFFIX = 'Asian_Alone_Or_In_Combination_With_One_Or_More_Other_Races') AND (questions.question_universe = 'Asian Alone Or In Combination With One Or More Other Races') AND (answers.answer_name = 'Total')
          GROUP BY 1),
          nathaw as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS nat_haw_alone_or_in_combo
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)

          WHERE (_TABLE_SUFFIX = 'Native_Hawaiian_And_Other_Pacific_Islander_Alone_Or_In_Any_Combination_By_Selected_Groups') AND (questions.question_universe = 'Native Hawaiian And Other Pacific Islander Alone Or In Combination With One Or More Other Races') AND (answers.answer_name = 'Total')
          GROUP BY 1),
          hisp as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS hispanic_or_latino
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)
          WHERE (_TABLE_SUFFIX = 'Hispanic_Or_Latino_Origin') AND (questions.question_universe = 'Total Population') AND (answers.answer_name = 'Hispanic or Latino')
          GROUP BY 1),
          white_non_hisp as (
          SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS white_non_hisp
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)
          WHERE (_TABLE_SUFFIX = 'Hispanic_Or_Latino_Origin_By_Race') AND (questions.question_universe = 'Total Population') AND (answers.answer_name = 'White alone') AND (((ARRAY_TO_STRING(answers.parent_answers,':')) = 'Not Hispanic or Latino'))
          GROUP BY 1),
          under_18 as (
           SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS under_18
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)
          WHERE (_TABLE_SUFFIX = 'Sex_By_Age') AND (questions.question_universe = 'Total Population') AND (answers.answer_name = 'Under 5 years' OR answers.answer_name = '5 to 9 years' OR answers.answer_name = '10 to 14 years' OR answers.answer_name = '15 to 17 years') AND (((ARRAY_TO_STRING(answers.parent_answers,':')) = 'Male' OR (ARRAY_TO_STRING(answers.parent_answers,':')) = 'Female'))
          GROUP BY 1),
          sixty_five_and_over as (
           SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS sixty_five_and_over
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)
          WHERE (_TABLE_SUFFIX = 'Sex_By_Age') AND (questions.question_universe = 'Total Population') AND (answers.answer_name = '65 and 66 years' OR answers.answer_name = '67 to 69 years' OR answers.answer_name = '70 to 74 years' OR answers.answer_name = '75 to 79 years' OR answers.answer_name = '80 to 84 years' OR answers.answer_name = '85 years and over') AND (((ARRAY_TO_STRING(answers.parent_answers,':')) = 'Male' OR (ARRAY_TO_STRING(answers.parent_answers,':')) = 'Female'))
          GROUP BY 1),
          eighteen_to_64 as (
           SELECT
            SUBSTR(logrecno_bg_map.geoid, 8, 12) AS logrecno_bg_map_block_group,
            COALESCE(SUM((SAFE_CAST(data_answers.value AS FLOAT64)) ), 0) AS eighteen_to_64
          FROM `acs_partitioned3.acs_*`  AS data
          LEFT JOIN UNNEST(data.answers) as data_answers
          LEFT JOIN acs.acs_questions_2015  AS questions ON data.question_id = questions.question_id
          INNER JOIN answers ON data.question_id = answers.question_id
                      AND data_answers.key = answers.answer_id
                      AND answers.leaf_node = true
          INNER JOIN ${logrecno_bg_map.SQL_TABLE_NAME} AS logrecno_bg_map ON logrecno_bg_map.row_id = CONCAT(UPPER(data.state_us_abbreviation), CAST(data.logical_record_number AS STRING))
                AND logrecno_bg_map.sumlevel = CAST(questions.max_sumlevel AS STRING)
          WHERE (_TABLE_SUFFIX = 'Sex_By_Age') AND (questions.question_universe = 'Total Population') AND answers.answer_name not in ('Under 5 years', '5 to 9 years', '10 to 14 years', '15 to 17 years', '65 and 66 years', '67 to 69 years', '70 to 74 years', '75 to 79 years', '80 to 84 years', '85 years and over') AND (((ARRAY_TO_STRING(answers.parent_answers,':')) = 'Male' OR (ARRAY_TO_STRING(answers.parent_answers,':')) = 'Female'))
          GROUP BY 1)
          SELECT
            total_population.logrecno_bg_map_block_group,
            CAST(total_population.total_population AS INT64) as total_population,
            CAST(housing_units.housing_units AS INT64) as housing_units,
            CAST(sex.female AS INT64) as female,
            CAST(sex.male AS INT64) as male,
            CAST(white.white_alone_or_in_combo AS INT64) as white_alone_or_in_combo,
            CAST(black.black_alone_or_in_combo AS INT64) as black_alone_or_in_combo,
            CAST(amind.amind_alone_or_in_combo AS INT64) as amind_alone_or_in_combo,
            CAST(asian.asian_alone_or_in_combo AS INT64) as asian_alone_or_in_combo,
            CAST(nathaw.nat_haw_alone_or_in_combo AS INT64) as nat_haw_alone_or_in_combo,
            CAST(hisp.hispanic_or_latino AS INT64) as hispanic_or_latino,
            CAST(white_non_hisp.white_non_hisp AS INT64) as white_non_hisp,
            CAST(under_18.under_18 AS INT64) as under_18,
            CAST(eighteen_to_64.eighteen_to_64 AS INT64) as eighteen_to_64,
            CAST(sixty_five_and_over.sixty_five_and_over AS INT64) as sixty_five_and_over
          FROM
            total_population
            LEFT JOIN housing_units on housing_units.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN sex on sex.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN white on white.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN black  on black.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN amind on amind.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN asian on asian.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN nathaw on nathaw.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN hisp on hisp.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN white_non_hisp on white_non_hisp.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN under_18 on under_18.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN eighteen_to_64 on eighteen_to_64.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
            LEFT JOIN sixty_five_and_over on sixty_five_and_over.logrecno_bg_map_block_group = total_population.logrecno_bg_map_block_group
          ;;
    persist_for: "1000 hours"
  }

  # Define your dimensions and measures here, like this:
  dimension: logrecno_bg_map_block_group {
    hidden: yes
    type: string
    sql: ${TABLE}.logrecno_bg_map_block_group ;;
    primary_key: yes
  }

  measure: total_population {
    description: "Total Population"
    type: sum
    sql: ${TABLE}.total_population ;;
  }

  # Household Measures
  measure: housing_units {
    type: sum
    group_label: "Households"
    sql: ${TABLE}.housing_units ;;
  }
  measure: avg_persons_house {
    type: number
    group_label: "Households"
    label: "Average Persons per Household"
    sql: ${total_population}/NULLIF(${housing_units}, 0) ;;
    value_format_name: decimal_2
  }

  # Sex Measures
  measure: female_population {
    type: sum
    sql: ${TABLE}.female ;;
    group_label: "Sex"
  }
  measure: male_population {
    type: sum
    sql: ${TABLE}.male ;;
    group_label: "Sex"
  }
  measure:  pct_male{
    type: number
    label: "Male % of Population"
    group_label: "Sex"
    sql: ${male_population}/NULLIF(${total_population}, 0) ;;
    value_format_name: percent_2
  }
  measure:  pct_female{
    type: number
    label: "Female % of Population"
    group_label: "Sex"
    sql: ${female_population}/NULLIF(${total_population}, 0) ;;
    value_format_name: percent_2
  }

  # Racial Measures

  measure: white_alone_or_in_combo {
    label: "White Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: ${TABLE}.white_alone_or_in_combo ;;
  }
  measure: black_alone_or_in_combo {
    label: "Black or African American Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: ${TABLE}.black_alone_or_in_combo ;;
  }
  measure: amind_alone_or_in_combo {
    label: "American Indian or Native Alaskan Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: ${TABLE}.amind_alone_or_in_combo ;;
  }
  measure: asian_alone_or_in_combo {
    label: "Asian Population (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: ${TABLE}.asian_alone_or_in_combo ;;
  }
  measure: nat_haw_alone_or_in_combo {
    label: "Native Hawaiian or Other Pacific Islander (Alone or in Combo with Other Races)"
    group_label: "Race"
    type: sum
    sql: ${TABLE}.nat_haw_alone_or_in_combo ;;
  }
  measure: white_non_hisp {
    label: "White, Non-Hispanic Population"
    group_label: "Race"
    type: sum
    sql: ${TABLE}.white_non_hisp ;;
  }
  measure: pct_white {
    label: "White % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${white_alone_or_in_combo}/NULLIF(${total_population}, 0) ;;
  }
  measure: pct_black {
    label: "Black/African American % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${black_alone_or_in_combo}/NULLIF(${total_population}, 0) ;;
  }
  measure: pct_asian {
    label: "Asian % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${asian_alone_or_in_combo}/NULLIF(${total_population}, 0) ;;
  }
  measure: pct_amind {
    label: "American Indian or Native Alaskan % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${amind_alone_or_in_combo}/NULLIF(${total_population}, 0) ;;
  }
  measure: pct_nathaw {
    label: "Native Hawaiian or Other Pacific Islander % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${nat_haw_alone_or_in_combo}/NULLIF(${total_population}, 0) ;;
  }
  measure: pct_white_nh {
    label: "White, Non-Hispanic % of Population"
    group_label: "Race"
    type: number
    value_format_name: percent_2
    sql: ${white_non_hisp}/NULLIF(${total_population}, 0) ;;
  }

  measure: hispanic_or_latino {
    label: "Hispanic or Latino Population (Any Race)"
    type: sum
    sql: ${TABLE}.hispanic_or_latino ;;
    group_label: "Hispanic/Latino"
  }
  measure: pct_hispanic_or_latino {
    label: "Hispanic or Latino % of Population (Any Race)"
    type: number
    sql: ${hispanic_or_latino}/NULLIF(${total_population}, 0) ;;
    group_label: "Hispanic/Latino"
    value_format_name: percent_2
  }
  measure: pct_non_hispanic_or_latino {
    label: "Non-Hispanic, Non-Latino % of Population (Any Race)"
    type: number
    sql: 1-(${hispanic_or_latino}/NULLIF(${total_population}, 0)) ;;
    group_label: "Hispanic/Latino"
    value_format_name: percent_2
  }
  measure: pct_white_nh2 {
    label: "White, Non-Hispanic % of Population"
    group_label: "Hispanic/Latino"
    type: number
    value_format_name: percent_2
    sql: ${white_non_hisp}/NULLIF(${total_population}, 0) ;;
  }

  measure: under_18 {
    label: "Population 17 years and younger"
    type: sum
    sql: ${TABLE}.under_18 ;;
    group_label: "Age"
  }
  measure: eighteen_to_64 {
    label: "Population 18 to 64 years"
    type: sum
    sql: ${TABLE}.eighteen_to_64 ;;
    group_label: "Age"
  }
  measure: sixty_five_and_over {
    label: "Population 65 years and older"
    type: sum
    sql: ${TABLE}.sixty_five_and_over ;;
    group_label: "Age"
  }
  measure: pct_under_18 {
    label: "% of Population 17 years and younger"
    type: number
    sql: ${under_18}/NULLIF(${total_population}, 0) ;;
    group_label: "Age"
    value_format_name: percent_2
  }
  measure: pct_18_64 {
    label: "% of Population 18 and 64 years"
    type: number
    sql: ${eighteen_to_64}/NULLIF(${total_population}, 0) ;;
    group_label: "Age"
    value_format_name: percent_2
  }
  measure: pct_65_over {
    label: "% of Population 65 and older"
    type: number
    sql: ${sixty_five_and_over}/NULLIF(${total_population}, 0) ;;
    group_label: "Age"
    value_format_name: percent_2
  }


}
