include: "questions.view"

view: answers {
  derived_table: {
    sql:
      SELECT *
      , MIN(answer_id) OVER (PARTITION BY question_id, answer_name, level) as min_answer_id
      FROM
        acs.acs_answers_2015_leaf
        ;;
  }

  dimension: question_id {
    hidden: yes
    sql: ${TABLE}.question_id ;;
  }

  dimension: answer_id {
    primary_key: yes
    suggest_persist_for: "120 hours"
    hidden: yes
  }

  dimension: answer_name {
    order_by_field: min_answer_id
    suggest_persist_for: "120 hours"
  }

  dimension: answer_name2 {
    sql: CONCAT(min_answer_id,': ', ${answer_name}) ;;
    suggest_persist_for: "120 hours"
    hidden: yes
  }

  dimension: level {
    label: "Answer Level"
    type: number
    sql: CAST(${TABLE}.level as INT64) ;;
    suggest_persist_for: "120 hours"
  }

  dimension: explore_now {
    sql: 1 ;;
    html: <a href="https://master.dev.looker.com/explore/acs/data?fields=data.percent_of_universe_selected,logrecno_bg_map.state,logrecno_bg_map.state_name&f[data.question_name]={{ questions.question_name_munged._filterable_value }}&f[questions.question_universe]={{ questions.question_universe._filterable_value }}&f[selected_answer.selected_answer_name]={{ answers.answer_name._filterable_value }}&f[data.selected_parent]={{ answers.parent_answers._filterable_value }}&sorts=data.percent_of_universe_selected+desc&limit=5000&column_limit=50&toggle=dat,pik,vis" target="_blank">Explore Now</a> ;;

  }
  dimension: leaf_node {
    hidden:yes
  }

  dimension: parent_answers {
    sql: ARRAY_TO_STRING(${TABLE}.parent_answers,':') ;;
  }
  measure: count {
    label: "Answer Count"
    type: count
    drill_fields: [answer_id, questions.name, answer.name, level]
  }

  dimension: min_answer_id {
    sql: SAFE_CAST(${TABLE}.min_answer_id as INT64) ;;
    hidden: yes
    }
}
