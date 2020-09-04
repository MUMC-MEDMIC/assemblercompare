# assemblercompare

this repo contains the complete data-preprocessing to generate assemblies using SPAdes (with and without error correction), Megahit, SKESA.  
Differences on SNP basis are checked using SKA.

* requirements:  
 conda   
 python >= 3.6.  
 snakemake.  
 
* usage:   
 Generate a samplesheet that is read by snakemake and launch entire workflow.
```
python assemblercompare.py -i {dir_with_subdir_samples} --cores {number_of_CPU_cores}
```



