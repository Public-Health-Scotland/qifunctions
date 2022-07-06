# qifunctions
Package for useful functions for the Quality Indicators team (phs.qualityindicators@phs.scot)

## Functions
create_ir - creates folder structure and sample structure for code.

``` r
create_ir("IR2022-55555")

create_ir("IR2022-55555", title = "Number of admissions", source = "SMR01")
```

## Installation

To install `qifunctions`, the package `remotes` is required, and can be
installed with `install.packages("remotes")`.

You can then install `qifunctions` on RStudio server from GitHub with:

``` r
remotes::install_github("Public-Health-Scotland/qifunctions",
  upgrade = "never"
)
```

Network security settings may prevent `remotes::install_github()` from
working on RStudio desktop. If this is the case, `qifunctions` can be
installed by downloading the [zip of the
repository](https://github.com/Public-Health-Scotland/qifunctions/archive/master.zip)
and running the following code (replacing the section marked `<>`,
including the arrows themselves):

``` r
remotes::install_local("<FILEPATH OF ZIPPED FILE>/qifunctions-master.zip",
  upgrade = "never"
)
```
