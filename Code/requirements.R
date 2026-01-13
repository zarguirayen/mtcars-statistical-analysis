# requirements.R
# Install required R packages for this project

required_packages <- c(
  "readr",
  "ggplot2",
  "gridExtra",
  "FactoMineR",
  "corrplot",
  "MASS",
  "pls"
)

installed <- rownames(installed.packages())
to_install <- setdiff(required_packages, installed)

if (length(to_install) > 0) {
  install.packages(to_install)
}

cat("All required packages are installed.\n")
