view: data {
  sql_table_name: `acs_partitioned3.acs_*` ;;
  suggestions: no

  dimension: question_name {
    suggest_explore: partition_suggest
    suggest_dimension: partition_suggest.partition
    sql: _TABLE_SUFFIX ;;
  }

  dimension: min_geo {
    sql:  CONCAT(
            UPPER(${data.state_us_abbreviation})
            , CAST(${data.logical_record_number} AS STRING)
            ,'|'
            ,  CAST(${questions.max_sumlevel} AS STRING)
          ) ;;
  }


  dimension: row_id {hidden: yes}
  dimension: state_us_abbreviation {suggest_persist_for: "120 hours"}
  dimension: sequence {}
  dimension: logical_record_number {}
  dimension: question_id {hidden: yes}
  dimension: answers {hidden: yes}
  measure: count {
    type: count
  }

  dimension: id {
    primary_key: yes
    sql: CONCAT(${data.row_id}, '|', ${answers_key}) ;;
    hidden: yes
  }
  dimension: answers_key {
    sql: ${data_answers.key} ;;
    suggest_persist_for: "120 hours"
  }
  dimension: answers_value {
    type: number
    sql: SAFE_CAST(${data_answers.value} AS FLOAT64) ;;
  }

  measure: total {
    type: sum
    sql: ${answers_value} ;;
  }

  measure: question_universe_total {
    type: sum
    sql: CASE WHEN ${answers.leaf_node} = true THEN ${answers_value} ELSE NULL END ;;
  }


  measure: total_selected {
    type: sum
    sql: CASE WHEN ${selected_answer.answer_id} IS NOT NULL
      THEN ${answers_value} END ;;
  }

#   measure: total_base {
#     type: sum
#     sql: CASE WHEN ({% condition base_answer_name %}  ${selected_answer.answer_name} {%endcondition%})
#       THEN ${answers_value} END ;;
#   }

#   measure: percent_selected_of_base {
#     type: number
#     sql: ${total_selected} / NULLIF(${total_base},0) ;;
#     value_format_name: percent_2
#   }

  measure: percent_of_universe_selected {
    type: number
    sql: ${total_selected} / NULLIF(${question_universe_total},0) ;;
    value_format_name: percent_2
  }

  measure: total_blob {
    sql: pairs_sum_top_n(ARRAY_AGG(STRUCT(${answers.answer_name} as key,  ${answers_value} as value )), 50) ;;
  }

  measure: total_pie_graph_large {
    sql: pairs_sum_graph_ordered(ARRAY_AGG(pair_with_order(${answers.answer_name},${answers_value}, CAST(${answers.min_answer_id} AS FLOAT64) ))) ;;
    html:
      <IMG SRC="https://chart.googleapis.com/chart?cht=p&chd=s:Uf9a&chs=500x250&{{value}}">;;
  }

  measure: total_pie_graph_small {
    sql: ${total_pie_graph_large} ;;
    html:
      <IMG SRC="https://chart.googleapis.com/chart?cht=p&chd=s:Uf9a&chs=150x75&{{value}}">;;
  }

#   set: default_drills {
#     fields: [percent_selected_of_base, total_base, total_selected]
#   }
}

view: data_answers {
  dimension: key {hidden:yes}
  dimension: value {hidden: yes}
}
