


ska_distance:
    input:



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
localrule: skesa_ska

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

localrule: spades_ska


rule megahit:
    input:
        forward = lambda wildcards: SAMPLES[wildcards.sample]['forward'],
        reverse = lambda wildcards: SAMPLES[wildcards.sample]['reverse']
    output:
        "results/{sample}/megahit/assembly/final_contigs.fa"
    threads: 16
    params:
        "results/{sample}/megahit/assembly"
    conda:
        "envs/megahit.yaml"
    shell:
        "megahit -1 {input.forward} -2 {input.reverse} -o {params} "
        "-t {threads}"


rule megahit_ska:
    input:
        assembly = "results/{sample}/megahit/assembly/final_contigs.fa"
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
localrule:megahit_ska
