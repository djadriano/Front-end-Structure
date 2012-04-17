#!/bin/bash

cat >> /dev/stdout << EOF
# -----------------------------------
# create front-end structure
# By Adriano Fernandes
# twitter.com/djadriano
# djadrianof@gmail.com
# -----------------------------------
EOF

# -----------------------------------
# get parameters
# -----------------------------------

if [[ -z "$2" ]]
then
	echo "error: missing arguments"
	echo "usage: $0 project-directory project-namespace [ruby-version]"
	exit 1
fi

if [[ ! -z "$3" ]]
then
	ruby_version="$3"
else
	ruby_version=$(rvm current)
fi

project_directory="$1"
project_name=$(sed -e 's#.*/##' <<< "$project_directory")

project_namespace="$2"

# -----------------------------------
# replace spaces with underscores
# -----------------------------------

project_name=$(tr -s ' ' '_' <<< $project_name)
project_namespace=$(tr -s ' ' '_' <<< $project_namespace)

# -----------------------------------
# create directories
# -----------------------------------

if [[ -d "$project_directory" ]]
then
	echo "error: $project_directory already exists."
	exit 1
fi

mkdir -p "$project_directory"
if (( $? == 1 ))
then
	echo "error: could not create $project_directory"
	exit 1
fi

pushd "$project_directory" &>/dev/null

mkdir -p {config,_/{images,javascripts/{_app/{models,views,collections,routers},_vendors/{core,plugins}},stylesheets/{core,pages,shared,vendors}}};

# -----------------------------------
# create app.js
# -----------------------------------

cat > _/javascripts/_app/app.js << EOF
;(function(global) {

global.$project_namespace = {
  Models      : {},
  Views       : {},
  Collections : {},
  Routes      : {}
};

})(window);

\$(function() {
// START YOUR PROJECT HERE
})
EOF

# -----------------------------------
# get javascripts dependencies
# -----------------------------------

curl -L http://www.modernizr.com/downloads/modernizr-latest.js > _/javascripts/_vendors/core/modernizr.js
curl -L http://code.jquery.com/jquery.min.js > _/javascripts/_vendors/core/jquery.js
curl -L https://raw.github.com/douglascrockford/JSON-js/master/json2.js > _/javascripts/_vendors/core/json2.js
curl -L http://documentcloud.github.com/underscore/underscore-min.js > _/javascripts/_vendors/core/underscore.js
curl -L http://documentcloud.github.com/backbone/backbone-min.js > _/javascripts/_vendors/core/backbone.js

# -----------------------------------
# create main.scss
# -----------------------------------

cat > _/stylesheets/main.scss << EOF
@import 'compass';

// ----------------------------------
// core
// -----------------------------------
@import 'core/grid';
@import 'core/colors';
@import 'core/reset';
@import 'core/forms';
@import 'core/headings';
@import 'core/typography';

// ----------------------------------
// shared
// -----------------------------------
@import 'shared/structure';

// ----------------------------------
// vendors
// -----------------------------------

// ----------------------------------
// pages
// -----------------------------------
EOF

# -----------------------------------
# create reset.scss
# -----------------------------------

cat > _/stylesheets/core/_reset.scss << EOF
@import 'compass/reset';
@import 'compass/reset/utilities';

@include global-reset;
EOF

# -----------------------------------
# create colors.scss
# -----------------------------------

touch _/stylesheets/core/_colors.scss

# -----------------------------------
# create forms.scss
# -----------------------------------

touch _/stylesheets/core/_forms.scss

# -----------------------------------
# create headings.scss
# -----------------------------------

touch _/stylesheets/core/_headings.scss

# -----------------------------------
# create typography.scss
# -----------------------------------

touch _/stylesheets/core/_typography.scss

# -----------------------------------
# create grid.scss
# -----------------------------------

cat > _/stylesheets/core/_grid.scss << EOF
@import 'susy';

// Grid ----------------------------------------------------------------------

\$total-cols             : 12;
\$col-width              : 4em;
\$gutter-width           : 1em;
\$side-gutter-width      : \$gutter-width;

\$show-grid-backgrounds  : true;
EOF

# -----------------------------------
# create structure.scss
# -----------------------------------

touch _/stylesheets/shared/_structure.scss

# -----------------------------------
# create index.html
# -----------------------------------

cat > index.html << EOF
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=UTF-8">
<title>Page Title</title>
</head>
<body>

</body>
</html>
EOF

# -----------------------------------
# create Gemfile
# -----------------------------------

cat > Gemfile << EOF
source 'http://rubygems.org'

gem 'compass', '0.11.1'
gem 'compass-susy-plugin', '0.9'
EOF

# -----------------------------------
# create .rvmrc
# -----------------------------------

cat > .rvmrc << EOF
rvm use $ruby_version@$project_name
EOF

# -----------------------------------
# create compass config
# -----------------------------------

bundle install
compass config -r susy

# -----------------------------------
# create gemset with project name
# -----------------------------------

rvm gemset create $project_name

# -----------------------------------
# done!
# -----------------------------------

popd &>/dev/null

echo "$project_name created successfully!"
echo "created in $project_directory using ruby version $ruby_version"

