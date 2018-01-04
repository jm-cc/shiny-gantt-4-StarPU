class tasksRec:
    """Class that allows to store a tasks.rec file from StarPU fxt in an exploitable format"""
    def __init__(self,input_file):
        self.file=input_file
        current_id=-1
        current_entry={}
        current_mpi_rank=-1
        self.all_jobs={}
        for line in input_file:
            if (line.strip()=="" and current_entry):
                key="{}_{}".format(current_mpi_rank,current_id)
                self.all_jobs[key]=current_entry
                current_id=-1
                current_entry={}
            else: 
                tmp=line.split(":")
                if (tmp[0]=="JobId"):
                    current_id=int(tmp[1])
                    current_entry[tmp[0]]=current_id
                elif (tmp[0]=="DependsOn"):
                    current_entry[tmp[0]]=[int(job) for job in tmp[1].split()]
                elif (tmp[0]=="MPIRank"):
                    current_mpi_rank=int(tmp[1])
                    current_entry[tmp[0]]=current_mpi_rank
                elif (tmp[0]=="WorkerId"):
                    current_entry[tmp[0]]=int(tmp[1])
                elif (tmp[0] in ["SubmitTime","StartTime","EndTime"]):
                    current_entry[tmp[0]]=float(tmp[1])
                else:
                    current_entry[tmp[0]]=tmp[1].strip()

    def convert2csv(self,output_file):
        header="JobId,Name,Model,MPIRank,WorkerId,SubmitTime,StartTime,EndTime,Duration,Parameters\n"
        line="{},{},{},{},{},{},{},{},{},{}\n"

        output_file.write(header)
        for j in self.all_jobs.values():
            if j.get("StartTime",None):
                duration=float(j["EndTime"])-float(j["StartTime"])
                job_id="task_"+str(j["MPIRank"])+"_"+str(j["JobId"])
                toprint=line.format(job_id,
                                    j.get("Name",""),
                                    j.get("Model",""),
                                    j.get("MPIRank",""),
                                    j.get("WorkerId",""),
                                    j.get("SubmitTime",""),
                                    j.get("StartTime",""),
                                    j.get("EndTime",""),
                                    duration,
                                    j.get("Parameters",""))
                output_file.write(toprint)

def main():
    import argparse
    parser= argparse.ArgumentParser(description="Convert a tasks.rec to a csv suitable for import in R.")
    parser.add_argument("input_file",nargs='?',type=argparse.FileType('r'),default="tasks.rec",help="tasks.rec file from starpu_fxt_tool")
    parser.add_argument("output_file",nargs='?',type=argparse.FileType('w'),default="tasks.csv",help="destination file")
    args = parser.parse_args()

    t=tasksRec(args.input_file)
    t.convert2csv(args.output_file)

if __name__ == '__main__':
    main()