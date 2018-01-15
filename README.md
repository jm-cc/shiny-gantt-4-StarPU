# shinyGantt 4 StarPU

Collection of python and R scripts aiming at doing post-mortem analysis of an execution of a StarPU program.

*dag2pydict* takes a *dag.dot* file and can find all predecessors of a given task.

*tasksRec.py* converts a *tasks.rec* to a csv that can be easily read with R.

*gantt.R* generates the gantt.

*shinyGantt* allows to display the gantt in a browser. It is possible to zoom using the small gantt. The *gantt* global variable is used to choose the gantt to display. The *DisplayState* column is used by default to choose the color of the tasks. When clicking near the _start_ of a task, infos are displayed in the text box.

# Typical usage

- Convert tasks.rec to readable csv.
```shell
$> python tasksRec.py tasks.rec tasks.csv
```
- In R, to display the Gantt, assuming all your files are in the same place (scripts and tasks.csv): 
```R
> #test
> library(ggplot2)
> library(shiny)
> setwd("path/to/files")
> #Load the gantt
> tmp=read_paje_trace("tasks.csv")
> t=prepare_trace(tmp)
> #Fill the gantt global variable (used by shinyGantt)
> gantt=t
> #Launch the shiny app.
> runApp("shinyGantt")
```
