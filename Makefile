RMD_FILES = proposal/problemdefinition.Rmd \
  proposal/proposal.Rmd \
  proposal/requirements.Rmd \
  proposal/signatories.Rmd \
  proposal/success.Rmd \
  proposal/timeline.Rmd

proposal: html md
html: out/isc-proposal.html
pdf: out/isc-proposal.pdf
md: isc-proposal.md

out/isc-proposal.html: isc-proposal.Rmd $(RMD_FILES)
	Rscript -e "rmarkdown::render('$<', output_format = 'html_document', output_dir = 'out', quiet = TRUE)"

out/isc-proposal.pdf: isc-proposal.Rmd $(RMD_FILES)
	Rscript -e "rmarkdown::render('$<', output_format = 'pdf_document', output_dir = 'out', quiet = TRUE)"

isc-proposal.md: isc-proposal.Rmd $(RMD_FILES)
	Rscript -e "rmarkdown::render('$<', output_format = 'github_document', output_dir = '.', quiet = TRUE)"

.PHONY: proposal html pdf md
