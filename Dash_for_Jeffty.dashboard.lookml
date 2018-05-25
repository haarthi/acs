- dashboard: dashboard_for_jeffty
  title: Dashboard for Jeffty
  layout: newspaper
  embed_style:
    background_color: "#000000"
    show_title: true
    title_color: "#3a4245"
    show_filters_bar: true
    tile_text_color: "#3a4245"
    text_tile_text_color: ''
  elements:
  - title: Llook
    name: Llook
    model: american_community_survey
    explore: fast_facts
    type: looker_line
    fields:
    - fast_facts.stusab
    - bg_facts.pct_hispanic_or_latino
    - bg_facts.total_population
    sorts:
    - bg_facts.pct_hispanic_or_latino desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    series_types: {}
    y_axes:
    - label: ''
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: bg_facts.total_population
        name: Fast Facts Total Population
        axisId: bg_facts.total_population
    - label:
      maxValue:
      minValue:
      orientation: right
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: bg_facts.pct_hispanic_or_latino
        name: Fast Facts Hispanic or Latino % of Population (Any Race)
        axisId: bg_facts.pct_hispanic_or_latino
    listen:
      Pop: bg_facts.total_population
      Pop2: bg_facts.pct_hispanic_or_latino
    row: 0
    col: 0
    width: 8
    height: 6
  - name: Look
    title: Llook
    model: american_community_survey
    explore: fast_facts
    type: looker_line
    fields:
    - fast_facts.stusab
    - bg_facts.pct_hispanic_or_latino
    - bg_facts.total_population
    sorts:
    - bg_facts.pct_hispanic_or_latino desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    series_types: {}
    y_axes:
    - label: ''
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: bg_facts.total_population
        name: Fast Facts Total Population
        axisId: bg_facts.total_population
    - label:
      maxValue:
      minValue:
      orientation: right
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: bg_facts.pct_hispanic_or_latino
        name: Fast Facts Hispanic or Latino % of Population (Any Race)
        axisId: bg_facts.pct_hispanic_or_latino
    listen:
      Pop: bg_facts.total_population
      Pop: bg_facts.pct_hispanic_or_latino
    row: 0
    col: 8
    width: 8
    height: 6
  - name: New Look
    title: New Look
    model: american_community_survey
    explore: fast_facts
    type: looker_line
    fields:
    - fast_facts.stusab
    - bg_facts.pct_hispanic_or_latino
    - bg_facts.total_population
    sorts:
    - bg_facts.pct_hispanic_or_latino desc
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    show_null_points: true
    point_style: none
    interpolation: linear
    series_types: {}
    y_axes:
    - label: ''
      maxValue:
      minValue:
      orientation: left
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: bg_facts.total_population
        name: Fast Facts Total Population
        axisId: bg_facts.total_population
    - label:
      maxValue:
      minValue:
      orientation: right
      showLabels: true
      showValues: true
      tickDensity: default
      tickDensityCustom: 5
      type: linear
      unpinAxis: false
      valueFormat:
      series:
      - id: bg_facts.pct_hispanic_or_latino
        name: Fast Facts Hispanic or Latino % of Population (Any Race)
        axisId: bg_facts.pct_hispanic_or_latino
    listen:
      Pop: bg_facts.total_population
      Pop: bg_facts.pct_hispanic_or_latino
    row: 0
    col: 16
    width: 8
    height: 6
  filters:
  - name: Pop
    title: Pop
    type: number_filter
    default_value: ">1000000"
    allow_multiple_values: true
    required: false
    # model: american_community_survey
    # explore: fast_facts
    # listens_to_filters: []
    # field: bg_facts.total_population
  - name: Pop2
    title: Pop2
    type: number_filter
    default_value: ">0.22"
    allow_multiple_values: true
    required: false
    # model: american_community_survey
    # explore: fast_facts
    # listens_to_filters: []
    # field: bg_facts.pct_hispanic_or_latino
