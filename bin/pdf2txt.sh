#Usage - pdf2txt.sh 2017
echo $1
pdftotext -layout Jan-$1-1.pdf
pdftotext -layout Jan-$1-2.pdf
pdftotext -layout Feb-$1-1.pdf
pdftotext -layout Feb-$1-2.pdf
pdftotext -layout Mar-$1-1.pdf
pdftotext -layout Mar-$1-2.pdf
pdftotext -layout Apr-$1-1.pdf
pdftotext -layout Apr-$1-2.pdf
pdftotext -layout May-$1-1.pdf
pdftotext -layout May-$1-2.pdf
pdftotext -layout Jun-$1-1.pdf
pdftotext -layout Jun-$1-2.pdf
pdftotext -layout Jul-$1-1.pdf
pdftotext -layout Jul-$1-2.pdf
pdftotext -layout Aug-$1-1.pdf
pdftotext -layout Aug-$1-2.pdf
pdftotext -layout Sep-$1-1.pdf
pdftotext -layout Sep-$1-2.pdf
pdftotext -layout Oct-$1-1.pdf
pdftotext -layout Oct-$1-2.pdf
pdftotext -layout Nov-$1-1.pdf
pdftotext -layout Nov-$1-2.pdf
pdftotext -layout Dec-$1-1.pdf
pdftotext -layout Dec-$1-2.pdf


