
devtools::install_github("bergant/datamodelr")
library(RPostgreSQL)
library(datamodelr)
library(DiagrammeR)

#> Loading required package: DBI
con <- dbConnect(dbDriver("PostgreSQL"), dbname="dvdrental", user ="postgres")
sQuery <- dm_re_query("postgres")
dm_dvdrental <- dbGetQuery(con, sQuery) 
dbDisconnect(con)
#> [1] TRUE

file_path <- system.file("~/builds/algo0ritmos/participantes/federico/data_model_YAML.yml")
dm <- datamodelr::dm_read_yaml(file_path)

dm <-
  datamodelr::dm_read_yaml(text = "
# data model segments
- segment: &gen Generation
- segment: &coo Coordination
- segment: &inter Interpretation
# Tables and columns
- table: Intruments
  segment: *inter
  columns:
    Intrument ID: {key: yes}
    Ecuation:
- table: MachineLearning
  segment: *gen
  columns:
    corpus ID: {key: yes}
    Ecuation:
- table: Inspiration
  segment: *gen
  columns:
    storm ID: {key: yes}
    Instrument:
    mood: {ref: mood}
- table: eucli
  segment: *gen
  columns:
    ADRS ID: {key: yes}
    Config: {ref: Intrument}
    Alter config: {ref: Intrument}
    Order date:
    Requested ship date:
    Status:
- table: mood
  segment: *coo
  columns:
    mood ID: {key: yes}
    join: {ref: Intrument}
    Alter join: {ref: Intrument}
    Order date:
    Requested ship date:
    Status:
- table: part
  segment: *coo
  columns:
    Part ID: {key: yes, ref: Order}
    Line number: {key: yes}
    Order item: {ref: larry}
    Quantity:
    Price:
- table: larry
  segment: *coo
  display: accent1
  columns:
    larry ID: {key: yes}
    Player: {ref: Instrument}
    Description:
    Category:
    Size:
    Color:
    mood: {ref: mood}
- table: player
  segment: *inter
  columns:
    Player ID: {key: yes, ref: Order}
    Line number: {key: yes}
    Order item: {ref: part}
    Quantity:
    Price:
")
dm <- datamodelr::as.data_model(dm)
dm_dvdrental_seg <- dm_set_segment(dm, table_segments)
graph <- dm_create_graph(dm, rankdir = "RL", view_type = "keys_only")
dm_render_graph(graph)
