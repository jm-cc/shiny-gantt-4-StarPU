import re
import time

class dag2dicts:
    """Class that parses a dag.dot files.
    give access to the list of each predecessors and successors for each task"""
    task_dep_pattern="(?P<ltask>\"(mpi|task)_[0-9]+_[0-9]+\")->(?P<rtask>\"(mpi|task)_[0-9]+_[0-9]+\")"

    def __init__(self,input_file):
        self.successors={}
        self.predecessors={}        
        for l in open(input_file,'r'):
            m=re.search(dag2dicts.task_dep_pattern,l)
            if m:
                ltask=m.group("ltask").strip("\"")
                rtask=m.group("rtask").strip("\"")
                self.successors.setdefault(ltask,set()).add(rtask)
                self.predecessors.setdefault(rtask,set()).add(ltask)


    def get_all_predecessors(self,task_id):
        res=set()
        todo=self.predecessors.get(task_id,set()).copy()
        marked={}
        while(todo):
            p=todo.pop()
            if p not in marked:
                marked[p]=1
                res.add(p)
                tmp=self.predecessors.get(p,set())
                for e in tmp:
                    todo.add(e)
        return res

