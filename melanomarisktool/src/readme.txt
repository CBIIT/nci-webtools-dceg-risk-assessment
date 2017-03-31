## make sure node and node package manager are installed first

## make sure gulp and gulp-cli are installed globally
npm install --global gulp gulp-cli

	https://docs.npmjs.com/getting-started/installing-node

###

## get application dependencies (while in 'src' folder)

npm install

ONLY EDIT FILES UNDER THE SRC DIRECTORY (except for python files or other files that are not apart of the compilation process)

## While in 'src' directory, run this command to copy files to development directory, if using WSGI (or change destination to move to another development directory)

(Ex.)
gulp && cp ../index.html ../calculator.html ../about.html ../styles.css ../rat.js  /analysistools/public_html/apps/melanomarisktool/app/


OR

gulp && cp [file(s) to copy] [Destination directory]



If changes are made to (Python scripts, new images/resources) they 
will need to be copied over to the development directory as well

Resources

	Jade (Renamed Pug)
	Stylus
	Gulp

	https://scotch.io/tutorials/automate-your-tasks-easily-with-gulp-js
	http://stylus-lang.com/
	http://learnjade.com/
	https://www.sitepoint.com/jade-tutorial-for-beginners/
	https://pugjs.org/api/getting-started.html