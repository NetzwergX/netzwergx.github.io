# name of the repository
repoName:=$(shell basename $(CURDIR))
# name of current branch
branch:=$(shell git rev-parse --abbrev-ref HEAD) 

# build process
# built with jekyll
# empty tmp dir
# move site to tmp dir
# switch to master
# delete old files from master
# move site to master
# add all files to master
# commit changes
# push master to upstream
# switch back to previous branch
all : 
	jekyll --safe --pygments
	rm -rf /tmp/$(repoName)/
	mv _site/ /tmp/$(repoName)/
	git checkout master
	rm -rf *
	mv  /tmp/$(repoName)/* ./
	git add --all
	git commit -a -m "Rebuilt jekyll page"
	git push upstream master
	git checkout $(branch)

# Remove the already built page
.PHONY : clean
clean :
	rm -rf _site/
# End of makefile 