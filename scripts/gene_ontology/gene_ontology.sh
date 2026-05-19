#!/bin/bash
#SBATCH --job-name=GO           
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/scripts/out_logs/gene_onology_%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/scripts/out_logs/gene_ontology_%j.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/scripts/gene_ontology/       

module load r/4.4.1-dmartinez

Rscript gene_ontology.r
