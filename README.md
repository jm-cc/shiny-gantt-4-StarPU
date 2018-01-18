# shinyGantt 4 StarPU

Collection of python and R scripts aiming at doing post-mortem analysis of an execution of a StarPU program.

*dag2pydict* takes a *dag.dot* file and can find all predecessors of a given task.

*tasksRec.py* converts a *tasks.rec* to a csv that can be easily read with R. This kind of trace is lighter compared to paje generated trace but shows only tasks events.

*paje2csv.sh* converts a paje trace to a csv. Richer than tasks.rec generated trace since it contains runtime state (notably sleeping, overhead and mpi communication thread status). **pj_dump** must be available. (see [PajeNG](https://github.com/schnorr/pajeng))

*gantt.R* generates the gantt.
(The **prepare_trace** function should be adapted to your needs and the input. By default, it is adapted for a *tasks.rec* generated trace.)

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
- If you want to generate a gantt from a paje trace, do the following :
```shell
$> ./paje2csv.sh input.paje tasks
```
Be sure that the *prepare_trace* function is modified. By default, it is designed to take its input from a *tasks.rec-generated* csv file.
