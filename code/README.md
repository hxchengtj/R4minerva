#This is a Document about how to merge the data.tables from 4 diff APPLICATIONS.
#1> QC.sample.xls <from Antonio> 
#   Read the DateSet to merge with data from PennCNV, iPattern, QuantiSNP
#   IBS <FAIL> means <duplicatation>: <HOW to certificate which 2 samples are duplicatation>
#   <Just use RESULTS from GenomicStudio, sample.cnv.txt<CNV data> >
#   <Compare the 2 samples'CNV, colum[allels1, allele2, and Combine TWO]<on same SNP>----this means genotyping>
#2> PennCNV
#   READ the 6 cols from the QC.txt 
#3> iPattern
#   <2 files   all_all_sample  all_all_cnv>
#   <smaple, just use the first 2 cols: 1st Sample.ID, 2nd used as LRR_SD>
#   <cnv, delete X,Y only use Chr(1:22), and table to calu, CNV in each sample>
#4> QuantiSNP
#   <each sample have a final report>
#   <each sample just delete Chr:23, remain 1:22, Calculate mean of LRR_SD and BAF_SD, and the No. of Lines is NumCNV>
#   <each sample generate one ROW as in the final dataSet>
#   <combine all the samples> 
