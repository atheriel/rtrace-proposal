RMD_FILES = proposal/problemdefinition.Rmd \
  proposal/proposal.Rmd \
  proposal/requirements.Rmd \
  proposal/signatories.Rmd \
  proposal/success.Rmd \
  proposal/timeline.Rmd

proposal: html
html: out/isc-proposal.html
pdf: out/isc-proposal.pdf

out/isc-proposal.html: isc-proposal.Rmd $(RMD_FILES)
	Rscript -e "rmarkdown::render('$<', output_format = 'html_document', output_dir = 'out', quiet = TRUE)"

out/isc-proposal.pdf: isc-proposal.Rmd $(RMD_FILES)
	Rscript -e "rmarkdown::render('$<', output_format = 'pdf_document', output_dir = 'out', quiet = TRUE)"

.PHONY: proposal html pdf
