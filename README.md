# Documentación del proyecto: Impact of spaceflight and artificial gravity on sulfur metabolism in mouse liver: sulfur metabolomic and transcriptomic analysis
**Fecha de entrega: 20 de Mayo del 2025**


**Bioinformática y estadística 2**


**Semestre 4**

### Elaborado por:

-⁠ ⁠Equipo: 3

-⁠ ⁠Integrantes:

• Diana Barrientos González (dbarrientos): [diana.barrientos.glz\@gmail.com](mailto:diana.barrientos.glz@gmail.com)

• Román Cervantes Levario (rcervantes): [ro.cerlev\@gmail.com](mailto:ro.cerlev@gmail.com)

• Jair Emiliano Contreras Rivera (jcontreras): [jairivera322\@gmail.com](mailto:jairivera322@gmail.com)

### Abstract
Para este análisis de RNA-seq, se compararon transcriptomas hepáticos de ratones bajo tres condiciones: microgravedad real (espacio, 30 días), gravedad artificial en Tierra y un grupo control en Tierra. Se analizaron datos obtenidos del BioProject PRJNA1005192, compuesto por nueve transcriptomas de hígado paired-end de mRNA enriquecida por Poly(A) y secuenciada con Illumina NovaSeq 6000, con tres réplicas biológicas por condición y una profundidad de secuenciación de entre 14.4 y 25.9 millones de lecturas de 300 pb promedio.

El procesamiento se realizó mediante TrimGalore para control de calidad y recorte de adaptadores, combinando FastQC y Cutadapt de forma automatizada. La cuantificación se realizó con Salmon mediante pseudoalineamiento basado en índices de k-meros, lo que permite una estimación precisa de la expresión sin alineamiento base a base, reduciendo el tiempo de cómputo significativamente.

Ambas herramientas fueron integradas en un pipeline reproducible con Nextflow. Posteriormente, se aplicó una corrección de batch effect con limma mediante regresión lineal sobre la matriz de expresión normalizada. El análisis de expresión diferencial se realizó con DESeq2, herramienta basada en un modelo binomial negativo diseñada para datos de conteos de RNA-seq con robusto desempeño en experimentos con pocas réplicas. Finalmente, el análisis de enriquecimiento funcional se realizó con g:Profiler consultando Gene Ontology y KEGG para identificar procesos biológicos y vías metabólicas enriquecidas.

El análisis identificó cambios en la expresión génica asociados a la adaptación fisiológica hepática frente a condiciones de microgravedad y gravedad artificial, con alteraciones en vías relacionadas a funciones hepáticas centrales. Adicionalmente, se observó una modificación en la expresión de genes vinculados a la producción de antioxidantes, en aparente compensación al agotamiento de compuestos de azufre, evidenciando el impacto de los cambios gravitacionales sobre la función hepática.

### Estrutura del repositorio

Este repositorio contiene una estructura diferente a la de de Ken, para observar la documentación de la estrutura de Ken, dirgirse a `Reporte_Equipo3_Rna_seq.qmd`. Las carpetas con su descripción se muestran a continuación así como el pie de imagen de cada una de ellas

### Estructura del repositorio

Este repositorio contiene una estructura diferente a la de Ken. Para observar la documentación de la estructura completa, diríjase a [`Reporte_Equipo3_Rna_seq.qmd`](#reporte_equipo3_rna_seqqmd). Las carpetas con su descripción se detallan a continuación:

- [`figures/`](figures/): Este directorio contiene todas las imágenes generadas durante el análisis y la documentación
  - [`antes_trimming_multqic_mean_quality.png`](figures/antes_trimming_multqic_mean_quality.png): Esta imagen es el resultado del multiqc en la sección mean quality antes de hacer el trimming
  - [`antes_trimming_gc_percent.png`](figures/antes_trimming_gc_percent.png): La imagen se refiere al porcentaje de GC en el multiqc antes de hacer el trimming
  - [`antes_trimming_q_scores.png`](figures/antes_trimming_q_scores.png): La imagen representa la distribución de calidades de las secuencias antes de hacer el trimming
  - [`antes_trimming_per_base_seq_content.png`](figures/antes_trimming_per_base_seq_content.png): Contiene un gráfico que muestra la proporción de bases A, T, G, C en el multiqc antes de hacer el trimming
  - [`antes_trimming_per_base_n_content.png`](figures/antes_trimming_per_base_n_content.png): Contiene la distribución de bases desconocidas en el multiqc antes de hacer el trimming
  - [`antes_trim_sequence_dup_lev.png`](figures/antes_trim_sequence_dup_lev.png): La imagen muestra la distribución de las secuencias duplicadas en el multiqc antes de hacer el trimming
  - [`antes_triming_adapters.png`](figures/antes_triming_adapters.png): La imagen muestra la distribución de los adaptadores en el multiqc antes de hacer el trimming
  - [`PCA_con_batch_effect.png`](figures/PCA_con_batch_effect.png): Esta imagen es el resultado del PCA con batch effect
  - [`scree_con_batch.png`](figures/scree_con_batch.png): La imagen muestra el scree plot (varianza) del PCA antes de la corrección de batch
  - [`scree_sin_batch.png`](figures/scree_sin_batch.png): La imagen muestra el scree plot del PCA con la corrección de batch
  - [`PCA_sin_batch.png`](figures/PCA_sin_batch.png): La imagen muestra el PCA sin los efectos del batch
  - [`PCA_sin_batch_elipses.pdf`](figures/PCA_sin_batch_elipses.pdf): La imagen muestra el PCA sin los efectos del batch y con los clusters identificados
  - [`Nf_workflow.jpg`](figures/Nf_workflow.jpg): Diagrama de flujo de nuestro trabajo
  - [`post_trimming_adapter_content.png`](figures/post_trimming_adapter_content.png): Distribución del contenido de adaptadores post trimming
  - [`post_trimming_gc_content.png`](figures/post_trimming_gc_content.png): Contenido de GC en el multiqc después de quitar sesgo de GC por PCR
  - [`post_trimming_general_statistics.png`](figures/post_trimming_general_statistics.png): Estadísticas generales del multiqc post trimming
  - [`post_trimming_overrepresented_Seq.png`](figures/post_trimming_overrepresented_Seq.png): Si es que hay secuencias sobrerrepresentadas después del trimming
  - [`post_trimming_per_base_N_content.png`](figures/post_trimming_per_base_N_content.png): Indica si hay alguna base no identificada
  - [`post_trimming_per_base_seq_content.png`](figures/post_trimming_per_base_seq_content.png): Muestra el contenido por base en el multiqc
  - [`post_trimming_per_seq_quality.png`](figures/post_trimming_per_seq_quality.png): Indica la calidad por secuencias post trimming
  - [`post_trimming_seq_duplication.png`](figures/post_trimming_seq_duplication.png): Si hay secuencias duplicadas post trimming, aquí se muestran
  - [`post_trimming_seq_length_distribution.png`](figures/post_trimming_seq_length_distribution.png): Muestra la distribución en el tamaño de las secuencias post trimming
  - [`post_trimming_sequence_quality.png`](figures/post_trimming_sequence_quality.png): La imagen contiene la calidad de las secuencias post trimming
  - [`SeqLenOverAll.png`](figures/SeqLenOverAll.png): Es la distribución del tamaño de las secuencias de los datos procesados, que varían entre 40-300 bp
  - [`ManhattanGO_A1G_vs_GC.png`](figures/ManhattanGO_A1G_vs_GC.png), [`ManhattanGO_MG_vs_A1G.png`](figures/ManhattanGO_MG_vs_A1G.png) y [`ManhattanGO_MG_vs_GC.png`](figures/ManhattanGO_MG_vs_GC.ng): plots de enriquecimiento funcional que compara los genes diferencialmente expresados que comparten los pares de gruppos, y categoriza en upregulated y downregulated, mientras más arriba se encuentren en el eje y más significativos son y los categoriza según las bases de datos `GO:BP = Gene Ontology Biological Process`, `KEGG = pathways metabólicos/señalización`, `REAC = Reactome` y `WP = WikiPathways`
  - [`barplotDOWN_GO_A1G_vs_GC.png`](figures/barplotDOWN_GO_A1G_vs_GC.png): Gráfica de las funciones biológicas subexpresadas en gravedad artificial respecto al control, clasifica según `Biological Process, KEGG = pathways metabólicos/señalización` y `WP = WikiPathways`
  - [`barplotDOWN_GO_MG_vs_A1G.png`](figures/barplotDOWN_GO_MG_vs_A1G.png): Gráfica de las funciones biológicas subexpresadas en microgravedad respecto a gravedad artificial, clasifica según `Biological Process` y `WP = WikiPathways`
  - [`barplotDOWN_GO_MG_vs_GC.png`](figures/barplotDOWN_GO_MG_vs_GC.png): Gráfica de las funciones biológicas subexpresadas en microgravedad respecto al control, , clasifica según `Biological Process, KEGG = pathways metabólicos/señalización, REAC = Reactome` y `WP = WikiPathways`
  - [`barplotUP_GO_A1G_vs_GC.png`](figures/barplotUP_GO_A1G_vs_GC.png): Gráfica de las funciones biológicas sobreexpresadas en gravedad artificial respecto al control,  clasifica según`Biological Process, KEGG = pathways metabólicos/señalización` y `REAC = Reactome`
  - [`barplotUP_GO_MG_vs_A1G.png`](figures/barplotUP_GO_MG_vs_A1G.png): Gráfica de las funciones biológicas sobreexpresadas en microgravedad respecto a gravedad artificial ,clasifica según `Biological Process, KEGG = pathways metabólicos/señalización` y `REAC = Reactome`
  - [`barplotUP_GO_MG_vs_GC.png`](figures/barplotUP_GO_MG_vs_GC.png): Gráfica de las funciones biológicas sobreexpresadas en microgravedad respecto al control, clasifica según `Biological Process, KEGG = pathways metabólicos/señalización, REAC = Reactome` y `WP = WikiPathways`
- [`Reporte_Equipo3_Rna_seq.qmd`](Reporte_Equipo3_Rna_seq.qmd): Es un archivo .qmd con toda la documentación del análisis, discusión, etc.
- [`metadatas.csv`](metadatas.csv): Este archivo contiene los metadatos del análisis
- [`scripts/`](scripts/): Este directorio contiene todos los scripts para realizar el análisis.
  - [`download_data/`](scripts/download_data/): Contiene el script utilizado para descargar los transcritos crudos mandado como job
  - [`rna_nextflow/`](scripts/rna_nextflow/): Dentro de esta carpeta se encuentran los scripts utilizados para correr el trimming y el pseudoalineamiento usando nextflow
  - [`samplesheet.csv`](scripts/samplesheet.csv): El input para nextflow
  - [`normalizacion_salmon/`](scripts/normalizacion_salmon/): Dentro de esta carpeta podremos encontrar dos scripts
    - [`normalizacion_salmon.R`](scripts/normalizacion_salmon/normalizacion_salmon.R): Este script se enfoca en importar los datos usando tximport
    - [`deseq2.R`](scripts/normalizacion_salmon/deseq2.R): Este código integra información del script anterior para hacer el PCA, la corrección de batch y el análisis de expresión diferencial
  - [`gene_ontology/`](scripts/gene_ontology/): Este script contiene el código para hacer el análisis de enriquecimiento
  - [`outlogs/`](scripts/outlogs/): Contiene los archivos de salida estándar `.out` y los archivos de error estándar `.err` que contiene los errores o warnings de cada script corrido.
      - [`DownloadData_1397.err`](scripts/outlogs/DownloadData_1397.err) y [`DownloadData_1397.out`](scripts/outlogs/DownloadData_1397.out) corresponden al script de `download_Data.sh` de la carpeta `download_data/`
      - [`deseq2_1818.err`](scripts/outlogs/deseq2_1818.err) y [`deseq2_1818.out`](scripts/outlogs/deseq2_1818.out) corresponden al script de `deseq2.R` de la carpeta `normalizacion_salmon/`
      - [`normalizacion_1792.err`](scripts/outlogs/normalizacion_1792.err) y [`normalizacion_1792.out`](scripts/outlogs/normalizacion_1792.out) corresponden al script de `normalizacion_salmon.R` de la carpeta `normalizacion_salmon/`
      - [`rnaseq_1478.err`](scripts/outlogs/rnaseq_1478.err) y [`rnaseq_1478.out`](scripts/outlogs/rnaseq_1478.out) corresponden al script de `rna_nextflow.sh` de la carpeta `rna_nextflow/`
      - [`gene_ontology_1817.err`](scripts/outlogs/gene_ontology_1817.err) y [`gene_ontology_1817.out`](scripts/outlogs/gene_ontology_1817.out) corresponden al script de `gene_ontology.sh` de la carpeta `gene_ontology/`
- [`DEG/`](DEG/): Directorio que contiene los resultados del análisis de expresión diferencial
    - `DEG_*.csv` : Resultados completos de DESeq2, todos los genes con sus estadísticas (log2FoldChange, pvalue, padj, etc.), sin ningún filtro
    - `SIG_*.csv` : Subconjunto de genes ya filtrado con padj < 0.05 y |LFC| ≥ 2 (todos los genes son significativos).
    - `res_*.RData`: Son los resultados de DESeq2 guardados en formato de R, para recargar los datos en R sin tener que correr DESeq2 de nuevo.

| biosample | grupo     | condicion                          | sample_ID           | srr_ID      |
|----------:|-----------|------------------------------------|---------------------|-------------|
| 36978221  | GC mice   | Control en la Tierra               | SAMN36978221_GC     | SRR25629473 |
| 36978220  | GC mice   | Control en la Tierra               | SAMN36978220_GC     | SRR25629472 |
| 36978219  | GC mice   | Control en la Tierra               | SAMN36978219_GC     | SRR25629471 |
| 36978218  | A1G mice  | Gravedad terrestre artificial      | SAMN36978218_A1G    | SRR25629470 |
| 36978217  | A1G mice  | Gravedad terrestre artificial      | SAMN36978217_A1G    | SRR25629469 |
| 36978216  | A1G mice  | Gravedad terrestre artificial      | SAMN36978216_A1G    | SRR25629468 |
| 36978215  | MG mice   | Microgravedad en el espacio       | SAMN36978215_MG     | SRR25629467 |
| 36978214  | MG mice   | Microgravedad en el espacio       | SAMN36978214_MG     | SRR25629466 |
| 36978213  | MG mice   | Microgravedad en el espacio       | SAMN36978213_MG     | SRR25629465 |

### Módulos

```
anaconda3/2025.06
fastqc/0.11.3
R/4.4.1
nextflow/23.04.1
java11
nf-core/rnaseq 3.14.0
singularity/3.7.0
deseq2/1.28.0
salmon/1.10.1
trimgalore/0.6.7
python/3.9.5
tximeta/1.12.0
```

### Explicación del pipeline y scripts

## Nexflow
```{bash}
#!/bin/bash
#SBATCH --job-name=rnaseq_equipo3
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/scripts/out_logs/rnaseq_%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/scripts/out_logs/rnaseq_%j.err
#SBATCH --time=24:00:00
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.25.0.9-7.el9.x86_64
export PATH=$JAVA_HOME/bin:$PATH

module load nextflow/23.04.1
module load singularity/3.7.0

nextflow run nf-core/rnaseq \
    -revision 3.14.0 \
    -profile singularity \
    --input /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/scripts/samplesheet.csv \
    --outdir /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/quality2 \
    --genome GRCm38 \
    --pseudo_aligner salmon \
    --skip_alignment \
    --trimmer trimgalore \
    --extra_salmon_quant_args '--gcBias true' \
    -resume
```
Explicación:
- `export java`: Nextflow usa java y se fijó el directorio pq había incompatibilidad de java
- `module load`: modulos a cargar nexftlow y singularity
- `profile singularity`: El comando dice que haga skip en revisar programas del cluster y vaya a singularity y aplique los programas que ya tiene.
- `input`: ruta absoluta de nuestra sampleesheet(CSV) que contiene metadata y rutas de las lecturas de secuenciación (FastQ).
- `outdir`: ruta absoluta de donde queremos los resultados.
- `genome`: a partir del nombre del genoma de referencia jalaŕa paths que ya lo tengan.
- `pseudo_aligner`: usa el pseudoalineamiento deseado en este caso Salmon pero pudo ser Kallisto por ejemplo.
- `skip_alignment`: por deafault hace un alineamiento tipo STAR, esta opción sirve para evitar que realice este paso.
- `trimmer trimgalore`: realiza trimming quita adaptadores, es más lento qeu trimmomatic pero se especializa en adaptadores por ende esta elección.
- `extra_salmon_quant_args`: evita el sesgo de GC provocados por la amplificación por PCR
- `resume`: si se detiene por algún fallo, podemos volver a correr y retomará a partir del donde se quedó sin necesidad de repetir todo desde un inicio.

Inputs de nextflow:

S tiene que crear un documento csv que contenga la información de la ruta de las secuencias para cada muestra. Así como especificar la orientación de la transcirpción, en nuestro caso lo fijamos a automático. En nuestro caso fue la siguiente tabla

```
sample,fastq_1,fastq_2,strandedness
SAMN36978221_GC,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629473_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629473_2.fastq.gz,auto
SAMN36978220_GC,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629472_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629472_2.fastq.gz,auto
SAMN36978219_GC,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629471_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629471_2.fastq.gz,auto
SAMN36978218_A1G,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629470_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629470_2.fastq.gz,auto
SAMN36978217_A1G,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629469_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629469_2.fastq.gz,auto
SAMN36978216_A1G,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629468_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629468_2.fastq.gz,auto
SAMN36978215_MG,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629467_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629467_2.fastq.gz,auto
SAMN36978214_MG,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629466_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629466_2.fastq.gz,auto
SAMN36978213_MG,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629465_1.fastq.gz,/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/SRR25629465_2.fastq.gz,auto

```


Outputs de nextflow:

Todos los resultados se van a guardar en quality2/ (/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/quality2) la estrucutra de las carpetas junto con cada salida fue previamente explicada. A contunuacion se menciona de forma breve los outputs:

Del control de calidad antes del trimming se obtienen reportes individuales por muestra en formato html ademas de un reporte global de MultiQC.

Del trimming con TrimGalore se obtiene por muestra un reporte de texto con el total de reads originales, el porcentaje de reads con adaptadores detectados, las bases removidas por baja calidad, las reads conservadas y el total de bases restantes. Además, se generan los FastQC resumidos un segundo reporte de MultiQC.

Del pseudoalineamiento con Salmon se obtiene por muestra un archivo quant.sf con la abundancia y conteo a nivel de transcrito y un quant.genes.sf a nivel de gen ademas de matrices como TPM, longitudes de genes y transcritos para todas las muestras, además del archivo tx2gene.tsv con la relación transcrito-gen. Finalmente se incluye informacion sobre la trazabilidad del pipeline, como versiones, opciones o errores


### Referencias

1)  Blaber, E. et al. (2017). Spaceflight Activates Autophagy Programs and the Proteasome in Mouse Liver. International Journal of Molecular Sciences

3)  Kurosawa R, Sugimoto R, Imai H, Atsuji K, Yamada K, Kawano Y, Ohtsu I, Suzuki K. Impact of spaceflight and artificial gravity on sulfur metabolism in mouse liver: sulfur metabolomic and transcriptomic\>

2)  Mhatre, S. et al. (2022). Artificial Gravity Partially Protects Space-induced Neurological Deficits in Drosophila melanogaster. Cell Reports

4)  Vinken M. Hepatology in space: Effects of spaceflight and simulated microgravity on the liver. Liver Int. 2022 Dec;42(12):2599-2606. doi: 10.1111/liv.15444. Epub 2022 Oct 12. PMID: 36183343.

5) Zhu, A., Ibrahim, J.G., Love, M.I. (2018) Heavy-tailed prior distributions for sequence count data: removing the noise and preserving large differences. Bioinformatics. https://doi.org/10.1093/bioinformatics/bty895

