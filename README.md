# assemblercompare

this repo contains the complete data-preprocessing to generate assemblies using SPAdes (with and without error correction), Megahit SKESA
and differences on SNP basis was checked using SKA.

* requirements:  
 conda   
 python >= 3.6.  
 snakemake.  
 
* usage:   
first generate a samplesheet that is read by snakemake.
```
python assemblercompare.py -i {dir_with_subdir_samples}
```

then you can run snakemake to generate all required files, from within this repo location using:
```
snakemake --use-conda --cores {number of cores available}
```
