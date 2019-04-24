#' @title Create App
#'
#' @description series of functions to actually wrap in electron and write installer
#'
#' @export

buildapp <- function() {
  # create electron-wrapped application
  RInno::create_app(
    app_name     = "NBADraft",
    app_dir      = paste0(getwd(),"/inst/app"),
    app_repo_url = "https://github.com/Andy-McCarthy/NBADraft",
    pkgs         = c("tidyverse", "shiny"),
    default_dir  = 'pf')
  # write installer
  RInno::compile_iss()
}
