devtools::install_github("bergant/datamodelr")
if(!require(DiagrammeR)){install.packages("DiagrammeR")}

library(datamodelr)
library(DiagrammeR)
options(browser = "brave")

#file_path <- system.file("~/builds/algo0ritmos/participantes/federico/data_model_YAML.yml")
#dm <- datamodelr::dm_read_yaml(file_path)

dm <-
    dm_read_yaml(text = "
# data model segments
- segment: &Gen Generation
- segment: &Coo Coordination
- segment: &Inter Interpretation
# Tables and columns
- table: Instruments
  segment: *Inter
  columns:
    Instrument ID: {key: yes}
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
    Config: {ref: Instruments}
    Alter config: {ref: Instruments}
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
    Join: {ref: Instruments}
    Alter join: {ref: Instruments}
    Order date:
    Requested ship date:
    Status:
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
    Player ID: {key: yes}
    Line number: {key: yes}
")

dm <- datamodelr::as.data_model(dm)
graph <- dm_create_graph(dm, rankdir = "RL", view_type = "keys_only")
fig_array_data_model <- dm_render_graph(graph)

dm_functional <-
    dm_read_yaml(text = "
# data model segments
- segment: &Top Topic
- segment: &Pub Publish
- segment: &Sub Subscriber
# Tables and columns
- table: Instruments
  segment: *Sub
  columns:
    Instrument ID: {key: yes}
    Filter:
    ADRS:
    NotePitch: {ref: Selected_from_Equations}
    TurnOn: {ref: Euclideans}
- table: Modifiers
  segment: *Sub
  columns:
    Modifier ID: {key: yes}
    Filter:
    ADRS: {ref: Selected_from_Equations}
- table: Inspirations
  segment: *Top
  columns:
    Inspiration ID: {key: yes}
    Instrument:
    mood: {ref: moods}
    Fram: {ref: Now}
- table: Euclideans
  segment: *Top
  columns:
    Euclidean ID: {key: yes}
    Config: {ref: liveCode}
    Alter config: {ref: liveCode}
    Order date:
    Requested ship date:
    Status:
    Larry: {ref: Now}
- table: Selected_from_Equations
  segment: *Top
  columns:
    equationsID: {key: yes}
    ecuation:
    latex:
    Status:
    Larry: {ref: Now}
- table: Conterpoints
  segment: *Top
  columns:
    Contrapunto ID: {key: yes}
    Contrapunto law:
    Status:
    Larry: {ref: Now}
- table: Pattern
  segment: *Pub
  columns:
    PatternID: {key: yes}
    Status:
- table: Parts
  segment: *Pub
  columns:
    Part ID: {key: yes}
    TurnOn item: {ref: Now}
- table: Now
  segment: *Pub
  display: accent2
  columns:
    Frame: {key: yes}
    Description:
    Category:
    Size:
    Color:
    Pattern: {ref: Pattern}
")
dm_functional <- datamodelr::as.data_model(dm_functional)
graph <- dm_create_graph(dm_functional, rankdir = "RL", view_type = "keys_only")
fig_functional_data_model <- dm_render_graph(graph)
##fig_functional_data_model
