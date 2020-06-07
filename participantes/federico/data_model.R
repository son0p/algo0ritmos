devtools::install_github("bergant/datamodelr")
library(datamodelr)
library(DiagrammeR)

#file_path <- system.file("~/builds/algo0ritmos/participantes/federico/data_model_YAML.yml")
#dm <- datamodelr::dm_read_yaml(file_path)

A data model not array, relational.how to traverse
ledger?
dm <-
    dm_read_yaml(text = "
# data model segments
- segment: &Gen Generation
- segment: &Coo Coordination
- segment: &Inter Interpretation
# Tables and columns
- table: Intruments
  segment: *Inter
  columns:
    Intrument ID: {key: yes}
    Filter:
    ADRS:
- table: Modifiers
  segment: *Inter
  columns:
    Modifier ID: {key: yes}
    Filter:
    ADRS:
- table: MachineLearnings
  segment: *Gen
  columns:
    corpus ID: {key: yes}
    Ecuation:
    Larry: {ref: Arrays}
- table: Inspirations
  segment: *Gen
  columns:
    Inspiration ID: {key: yes}
    Instrument:
    mood: {ref: moods}
    Larry: {ref: Arrays}
- table: euclideans
  segment: *Gen
  columns:
    Euclidean ID: {key: yes}
    Config: {ref: Intrument}
    Alter config: {ref: Intrument}
    Order date:
    Requested ship date:
    Status:
    Larry: {ref: Arrays}
- table: Ecuations
  segment: *Gen
  columns:
    ecuations ID: {key: yes}
    ecuation:
    latex:
    Status:
    Larry: {ref: Arrays}
- table: Conterpoints
  segment: *Gen
  columns:
    Contrapunto ID: {key: yes}
    Contrapunto law:
    Status:
    Larry: {ref: Arrays}
- table: Moods
  segment: *Coo
  columns:
    Mood ID: {key: yes}
    Join: {ref: Intruments}
    Alter join: {ref: Intruments}
    Order date:
    Requested ship date:
    Status:
- table: Parts
  segment: *Coo
  columns:
    Part ID: {key: yes, ref: Order}
    Line number: {key: yes}
    Order item: {ref: arrays}
    Quantity:
    Price:
- table: Arrays
  segment: *Coo
  display: accent2
  columns:
    ArrayID: {key: yes}
    Player: {ref: Players}
    Description:
    Category:
    Size:
    Color:
    Mood: {ref: Moods}
- table: Players
  segment: *Inter
  columns:
    Player ID: {key: yes, ref: Order}
    Line number: {key: yes}
")
dm <- datamodelr::as.data_model(dm)
dm_dvdrental_seg <- dm_set_segment(dm, table_segments)
graph <- dm_create_graph(dm, rankdir = "RL", view_type = "keys_only")
dm_render_graph(graph)


