## Copyright Broad Institute, 2020
## This script takes as input an array of single-sample gvcfs and merges them into a single gvcf
## using bcftools merge
##  
## TESTED: 
## Versions of other tools on this image at the time of testing:
##
## LICENSING : This script is released under the WDL source code license (BSD-3) (see LICENSE in https://github.com/broadinstitute/wdl). 
## Note however that the programs it calls may be subject to different licenses. Users are responsible for checking that they are authorized to run all programs before running this script. 
## Please see the docker for detailed licensing information pertaining to the included programs.
##

###########################################################################
#WORKFLOW DEFINITION
###########################################################################
workflow merge_gvcfs {

  Array[File] gvcfs
  Array[File] index_files
  String outprefix

  parameter_meta {
    gvcfs: "array of files representing single-sample gvcfs"
    index_files: "array of corresponding index files"
    outprefix: "string; output file prefix (to be appended to .g.vcf.gz)"
  }
  meta{
    author: "Alex Hsieh"
    email: "ahsieh@broadinstitute.org"
  }

  call bcftools_merge {
    input:
    gvcfs = gvcfs,
    index_files = index_files,
    outprefix = outprefix

  }

  #Outputs 
  output {
      File merged_gvcf = bcftools_merge.out
  }

}





###########################################################################
#Task Definitions
###########################################################################

# merges array of single-sample gvcfs into a single cohort gvcf
task bcftools_merge {
  Array[File] gvcfs
  Array[File] index_files
  String outprefix
  String outfname = "${outprefix}.g.vcf.gz"

  command {
    bcftools merge -l ${write_lines(gvcfs)} -o ${outfname} -O v
  }

  runtime {
    docker: "mwalker174/sv-pipeline:mw-00c-stitch-65060a1"
  }

  output {
    File out = "${outfname}"
  }
}

