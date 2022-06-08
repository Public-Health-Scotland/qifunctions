#
#' @title SMR01 completeness
#'
#' @description \code{create_ir} creates Informatio then Request folders and
#' code template required and opens a new project for the IR.
#'
#' @details Everything is created in cl-out
#'
#' @param ir_number A \code{character} string specifying the name of the IR,
#' including the year, e.g. IR2022-5555.
#'
#' @return Creates a series of directories in cl-out, a script that can be used
#' as a template for the IR and opens the project
#'
#' @example create_ir("IR2022-55555")
#'
#' @importFrom magrittr %>%
#' @importFrom magrittr %<>%
#'
#' @export


create_ir <- function(ir_number) {

  ir_year <- sub("-.*", "", ir_number)

  Sys.umask("002") # to set permissions right


  # Filepath changes depending on Desktop/Server
  platform <- dplyr::case_when(sessionInfo()$platform %in% c("x86_64-redhat-linux-gnu (64-bit)",
                                                             "x86_64-pc-linux-gnu (64-bit)") ~ "/conf/",
                               T ~ "//Isdsf00d03/")


  cl_out <- paste0(platform, "linkage/output/") # cl-out
  ir_folder <- paste0(cl_out, ir_year, "/", ir_number) # folder for IR

  # Function fails in directory already exists.
  if (dir.exists(ir_folder)) {
    stop(paste0("Folder ", ir_folder, " already exists."))
  }


  # Creating folder and subfolders
  dir.create(ir_folder, showWarnings = TRUE, recursive = TRUE, mode = "770")
  dir.create(paste0(ir_folder, "/data"), showWarnings = TRUE, recursive = TRUE, mode = "770")
  dir.create(paste0(ir_folder, "/emails"), showWarnings = TRUE, recursive = TRUE, mode = "770")
  dir.create(paste0(ir_folder, "/code"), showWarnings = TRUE, recursive = TRUE, mode = "770")

  # Creating script for code
  ir_script <- paste0(ir_folder, "/code/", ir_number , ".R")
  if (file.exists(ir_script) == F) {

    file.create(ir_script, overwrite = FALSE)

    # Writing IR template code in script
    ir_template <- "# Code for

    ###############################################.
    ## Packages ----
    ###############################################.
    library(odbc)          # For accessing SMRA databases
    library(dplyr)         # For data manipulation in the tidy way
    library(readr)         # For reading/writing CSVs
    library(tidyr)         # for pivoting data
    library(magrittr)      # for more pipe operators
    library(lubridate)     # for date operations

    #SMRA connection
    channel <- suppressWarnings(dbConnect(odbc(),  dsn='SMRA',
    uid=.rs.askForPassword('SMRA Username:'),
    pwd=.rs.askForPassword('SMRA Password:')))


    ###############################################.
    ## Extracting data ----
    ###############################################.
    # extracting cases from SMRA
    dataset <- as_tibble(dbGetQuery(channel, statement = paste0(
    'SELECT link_no, cis_marker, admission_date,
          main_condition, other_condition_1, other_condition_2, other_condition_3,
          other_condition_4, other_condition_5, hbtreat_currentdate
        FROM ANALYSIS.SMR01_PI  z
        WHERE admission_date between \"1 January 2016\" and \"31 December 2021\" '))) %>%
    setNames(tolower(names(.)))

    write_csv(output, 'data/output.csv') # saving file

    ###END"

    writeLines(ir_template, paste0(ir_folder, "/code/", ir_number , ".R"))

  } else {
    print("Script for this IR already exists")
  }

  # Creating R project and opens in new window
  rstudioapi::openProject(ir_folder, newSession = TRUE)

}


