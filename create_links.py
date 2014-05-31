import os,shutil

home_dir = "/home/makpoc/"
repo_dir = "/home/makpoc/git/github/dotfiles"

for file in os.listdir(repo_dir):
    file_path = os.path.abspath(file)
    if os.path.isfile(file_path): 
        print "> working on file %s" % file
        original_file = os.path.join(home_dir, "." + file)
        print "> original file is %s" % original_file
        if os.path.exists(original_file):
            print ">> original file found!"
            os.remove(original_file)
            print ">> original file deleted!"
            os.symlink(file_path, original_file)
            print ">> new symlink %s -> %s created" % (original_file, file_path)
        else:
            print ">> file %s does not exist" % original_file
            print ">> new symlink %s -> %s created" % (original_file, file_path)
    else:
        print "skipping path %s (it's a dir)" % file
