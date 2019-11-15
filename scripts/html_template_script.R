

# This script creates all the html templates needed for showcase
library(rmarkdown)
library(here)

themes <- c("default", "cerulean", "journal", "flatly",
            "darkly", "readable", "spacelab", "united",
            "cosmo", "lumen", "paper", "sandstone", "simplex", 
            "yeti", "null")
pretty <- c("cayman", "tactile", "architect", "leonids", "hpstr")
rmdformats <- c("readthedown", "html_clean", "html_docco", "material")
for(atheme in c(themes, pretty, rmdformats)) {
  # the .webm files in animation do not seem to be copied over
  # just copy from the main one
  output_dir <- here("output", "html", glue::glue("html_template_{atheme}_files/figure-html/"))
  anim1webm <- here("scripts", "html_template_files", "figure-html", "example-animation.webm")
  anim2webm <- here("scripts", "html_template_files", "figure-html", "example-animation2.webm")
  
  if(!dir.exists(output_dir)) {
    dir.create(output_dir, recursive = TRUE)
    file.copy(from = anim1webm, to = output_dir, overwrite = TRUE)
    file.copy(from = anim2webm, to = output_dir, overwrite = TRUE)
  }
  if(atheme == "null") {
    render(here("scripts", "html_template.Rmd"),
           output_format = html_document(theme = NULL),
           output_file = glue::glue("html_template_{atheme}.html"),
           output_dir = here("output", "html"))
  } else if(atheme %in% pretty){
    render(here("scripts", "html_template.Rmd"),
           output_format = prettydoc::html_pretty(theme = atheme),
           output_file = glue::glue("html_template_{atheme}.html"),
           output_dir = here("output", "html"))
  } else if(atheme %in% rmdformats) {
    render(here("scripts", "html_template.Rmd"),
           output_format = eval(parse(text = glue::glue("rmdformats::{atheme}()"))),
           output_file = glue::glue("html_template_{atheme}.html"),
           output_dir = here("output", "html"))    
  } else {
    render(here("scripts", "html_template.Rmd"),
           output_format = html_document(theme = atheme),
           output_file = glue::glue("html_template_{atheme}.html"),
           output_dir = here("output", "html"))
  }
  webshot::webshot(here("output", "html", glue::glue("html_template_{atheme}.html")),
                   file = here("images", glue::glue("html_template_{atheme}.png")),
                   delay = 1, 
                   vwidth = 600)
}


