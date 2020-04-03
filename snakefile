
configfile: "samples/samples.yaml"

SAMPLES = config["SAMPLES"]


rule all:
    input:
        "results/distances/distances.distances.tsv"


rule ska_distance:
    input:
        skesa = expand("results/data/{sample}/skesa_ska/{sample}_skesa.skf", sample = SAMPLES),
        #spades = expand("results/data/{sample}/skesa_ska/{sample}_spades.skf", sample = SAMPLES),
        megahit = expand("results/data/{sample}/megahit_ska/{sample}_megahit.skf", sample = SAMPLES)
    output:
        "results/distances/distances.distances.tsv"
    params:
        "results/distances/distances"
    threads: 1
    conda:
        "envs/SKA.yaml"
    shell:
        "ska distance {input} -o {params}"



rule skesa:
    input:
        forward = lambda wildcards: SAMPLES[wildcards.sample]['forward'],
        reverse = lambda wildcards: SAMPLES[wildcards.sample]['reverse']
    output:
        "results/{sample}/skesa/{sample}.fasta"
    conda:
        "envs/skesa.yaml"
    threads: 16
    log:
        "logs/assembly/{sample}/log.txt"
    shell:
        "skesa --fastq {input} --cores {threads} --use_paired_ends > {output}"
        " 2> {log}"

rule skesa_ska:
    input:
        assembly = "results/{sample}/skesa/{sample}.fasta"
    output:
        "results/data/{sample}/skesa_ska/{sample}_skesa.skf"
    params:
        "results/data/{sample}/skesa_ska/{sample}_skesa"
    conda:
        "envs/SKA.yaml"
    log:
        "logs/skesa_ska/{sample}/log.txt"
    shell:
        "ska fasta {input.assembly} -o {params} "
         "2> {log}"
localrules: skesa_ska

rule spades:
    input:
        forward = lambda wildcards: SAMPLES[wildcards.sample]['forward'],
        reverse = lambda wildcards: SAMPLES[wildcards.sample]['reverse']
    output:
        "results/{sample}/spades/assembly/assembly.fasta"
    threads: 16
    params:
        "results/{sample}/spades/assembly"
    conda:
        "envs/spades.yaml"
    shell:
        "spades.py -1 {input.forward} -2 {input.reverse} -o {params} "
        "-t {threads}"

rule spades_ska:
    input:
        assembly = "results/{sample}/skesa/{sample}.fasta"
    output:
        "results/data/{sample}/skesa_ska/{sample}_spades.skf"
    params:
        "results/data/{sample}/skesa_ska/{sample}_spades"
    conda:
        "envs/SKA.yaml"
    log:
        "logs/spades_ska/{sample}/log.txt"
    shell:
        "ska fasta {input.assembly} -o {params} "
         "2> {log}"

localrules: spades_ska


rule megahit:
    input:
        forward = lambda wildcards: SAMPLES[wildcards.sample]['forward'],
        reverse = lambda wildcards: SAMPLES[wildcards.sample]['reverse']
    output:
        "results/{sample}/megahit/assembly/final.contigs.fa"
    threads: 16
    params:
        dir = temp("temp/{sample}"),
        temp = temp("temp/{sample}/megahit")
    conda:
        "envs/megahit.yaml"
    shell:
        "mkdir -p {params.dir} && "
        "megahit -1 {input.forward} -2 {input.reverse} -o {params.temp} "
        "-t {threads} &&"
        "mv {params.temp}/final.contigs.fa {output}"


rule megahit_ska:
    input:
        assembly = "results/{sample}/megahit/assembly/final.contigs.fa"
    output:
        "results/data/{sample}/megahit_ska/{sample}_megahit.skf"
    params:
        "results/data/{sample}/megahit_ska/{sample}_megahit"
    conda:
        "envs/SKA.yaml"
    log:
        "logs/megahit_ska/{sample}/log.txt"
    shell:
        "ska fasta {input.assembly} -o {params} "
         "2> {log}"
localrules: megahit_ska
