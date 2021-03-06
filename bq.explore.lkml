include: "*.view*"


explore: fast_facts {
  from: logrecno_bg_map

  join: bg_facts {
    view_label: "Fast Facts"
    sql_on: ${fast_facts.block_group} = ${bg_facts.logrecno_bg_map_block_group};;
    relationship: one_to_one
  }

  join: tract_zcta_map {
    sql_on: ${fast_facts.geoid11} = ${tract_zcta_map.geoid11};;
    relationship: many_to_one
  }

  join: zcta_distances {
    sql_on: ${tract_zcta_map.ZCTA5} = ${zcta_distances.zip2} ;;
    relationship: one_to_one
    required_joins: [tract_zcta_map]
  }
}
