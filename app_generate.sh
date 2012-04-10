# -----------------------------------
# create front-end structure
# By Adriano Fernandes
# twitter.com/djadriano
# djadrianof@gmail.com
# -----------------------------------
  
# -----------------------------------
#get parameters
# -----------------------------------
project_name="$1";
namespace_name="$2";

# -----------------------------------
# app.js content
# -----------------------------------
app_js_content=";(function(global) {

global."$namespace_name" = {
  Models      : {},
  Views       : {},
  Collections : {},
  Routes      : {}
};

})(window);

\$(function() {
// START YOUR PROJECT HERE
})";

# -----------------------------------
# main.scss content
# -----------------------------------
main_scss_content="@import 'compass';

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
// -----------------------------------";

# -----------------------------------
# reset.scss
# -----------------------------------
reset_scss_content="@import 'compass/reset';
@import 'compass/reset/utilities';

@include global-reset;";

# -----------------------------------
# grid.scss
# -----------------------------------
grid_scss_content="@import 'susy';

// Grid ----------------------------------------------------------------------

\$total-cols             : 12;
\$col-width              : 4em;
\$gutter-width           : 1em;
\$side-gutter-width      : \$gutter-width;

\$show-grid-backgrounds  : true;";

# -----------------------------------
# index.html
# -----------------------------------
index_html_content="<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Page Title</title>
</head>
<body>

</body>
</html>";

# -----------------------------------
# Gemfile
# -----------------------------------
gemfile_content="source 'http://rubygems.org'

gem 'compass', '0.11.1'
gem 'compass-susy-plugin', '0.9'";

# -----------------------------------
# .rvmrc
# -----------------------------------
rvmrc_content="rvm use 1.9.2@"$project_name"";

# -----------------------------------
# create structure folders
# -----------------------------------
mkdir -p "$project_name"/{config,_/{images,javascripts/{_app/{models,views,collections,routers},_vendors/{core,plugins}},stylesheets/{core,pages,shared,vendors}}};

# -----------------------------------
#create app.js
# -----------------------------------
echo "$app_js_content" >> "$project_name"/_/javascripts/_app/app.js

# -----------------------------------
# get javascripts dependencies
# -----------------------------------
curl -L http://code.jquery.com/jquery.min.js > "$project_name"/_/javascripts/_vendors/core/jquery.js
curl -L http://www.json.org/json2.js > "$project_name"/_/javascripts/_vendors/core/json2.js
curl -L http://documentcloud.github.com/underscore/underscore-min.js > "$project_name"/_/javascripts/_vendors/core/underscore.js
curl -L http://documentcloud.github.com/backbone/backbone-min.js > "$project_name"/_/javascripts/_vendors/core/backbone.js

# -----------------------------------
#create main.scss
# -----------------------------------
echo "$main_scss_content" >> "$project_name"/_/stylesheets/main.scss

# -----------------------------------
#create reset.scss
# -----------------------------------
echo "$reset_scss_content" >> "$project_name"/_/stylesheets/core/_reset.scss

# -----------------------------------
#create colors.scss
# -----------------------------------
touch "$project_name"/_/stylesheets/core/_colors.scss

# -----------------------------------
#create forms.scss
# -----------------------------------
touch "$project_name"/_/stylesheets/core/_forms.scss

# -----------------------------------
#create headings.scss
# -----------------------------------
touch "$project_name"/_/stylesheets/core/_headings.scss

# -----------------------------------
#create typography.scss
# -----------------------------------
touch "$project_name"/_/stylesheets/core/_typography.scss

# -----------------------------------
#create grid.scss
# -----------------------------------
echo "$grid_scss_content" >> "$project_name"/_/stylesheets/core/_grid.scss

# -----------------------------------
#create structure.scss
# -----------------------------------
touch "$project_name"/_/stylesheets/shared/_structure.scss

# -----------------------------------
#create index.html
# -----------------------------------
echo "$index_html_content" >> "$project_name"/index.html

# -----------------------------------
#create Gemfile
# -----------------------------------
echo "$gemfile_content" >> "$project_name"/Gemfile

# -----------------------------------
#create .rvmrc
# -----------------------------------
echo "$rvmrc_content" >> "$project_name"/.rvmrc

# -----------------------------------
# enter in project structure
# -----------------------------------
cd "$project_name"

# -----------------------------------
# create compass config
# -----------------------------------
compass config -r susy

# -----------------------------------
#create gemset with project name
# -----------------------------------
rvm gemset create $project_name

echo 'project folders created successful!'