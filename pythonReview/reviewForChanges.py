import os
import subprocess

def reviewForChanges(oldFilePath, newFilePath, institution, fileRunMap):
    runToFile = {}
    with open(fileRunMap) as f:
        for line in f:
            (file, runFolder, order) = line.split(',')
            runToFile[int(order)] = [file,runFolder]
    print runToFile
       
    reviewFolderForChanges(oldFilePath, newFilePath, institution, runToFile)

def reviewFolderForChanges(oldFilePath, newFilePath, institution, runToFile):
    #read in file path
    oldFiles = os.listdir(oldFilePath)
    newFiles = os.listdir(newFilePath)
    
    #get names of files in order of name by create list
    fileStatus=""
    changedFiles=[ ]
    overView="Changes to the Following Files: \n"
    for newFile in newFiles:
        if newFile in oldFiles:
            status = reviewFileForChanges(oldFilePath+newFile, newFilePath+newFile)
            if (status.startswith("Changes in file")):
              changedFiles.append(newFile)  
              overView+= "  * " + newFile + " \n"
            fileStatus+=status
        else:
            fileStatus += "New File Found: " + newFile + "\n"
            changedFiles.append(newFile)  
            
    for oldFile in oldFiles:
        if oldFile not in newFiles:
            fileStatus += "File Missing: " + newFile + "\n"
    

    for i in range(1,len(runToFile)+1):
        if runToFile[i][0] in changedFiles:
            subprocess.call([runToFile[i][1]+"/run.sh"],
                            cwd=runToFile[i][1], stdout=open(os.devnull, 'wb'));



def reviewFileForChanges(oldFile, newFile):
    result = ""
    old_lines = file(oldFile).read().split('\n')
    new_lines = file(newFile).read().split('\n')
    
    old_lines_set = set(old_lines)
    new_lines_set = set(new_lines)
    
    old_added = old_lines_set - new_lines_set
    old_removed = new_lines_set - old_lines_set

    if not old_added and not old_removed:
        result += "No changes to file: " + newFile + "\n"
    else: 
        result += "Changes in file:" + newFile + "\n"
        for line in old_lines:
            if line in old_added:
                result += '-' + line.strip() + "\n"
            elif line in old_removed:
                result += '+', line.strip() + "\n"
    
        for line in new_lines:
            if line in old_added:
                result += '-' + line.strip() + "\n"
            elif line in old_removed:
                result += '+' + line.strip() + "\n"
        #run individual file using dictionary of files
        
    return result

if __name__ == "__main__":
    import sys
    reviewForChanges(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
    
