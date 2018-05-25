view: questions {
  sql_table_name: acs.acs_questions_2015 ;;
  dimension: question_id {
    primary_key: yes
    hidden: yes
  }
  dimension: question_category {}
  # The question as a regular string.
  dimension: question_name {
    suggest_persist_for: "120 hours"
  }
  dimension: max_sumlevel {
    # The smallest geographic level at which we have data for the question
    hidden: yes
    sql:${TABLE}.max_sumlevel ;;
  }

  dimension: smallest_geo {
    sql: CASE
          WHEN ${max_sumlevel} = 140
          THEN "Tract"
          WHEN ${max_sumlevel} = 150
          THEN "Block Group"
        END;;
    type: string
    label: "Smallest Geography Available"
  }

  dimension: question_name_munged {
    hidden: yes
    sql: REGEXP_REPLACE(${question_name}, r'[^A-Za-z0-9_]', '_')  ;;
    suggest_persist_for: "120 hours"
  }
  dimension: question_universe {}
  measure: count {
    label: "Question Count"
    type: count
  }
}
