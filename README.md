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
Para este análisis de RNA-seq, se utilizaron datos de un estudio que compara transcriptomas hepáticos de ratones bajo tres condiciones: ratones sometidos a microgravedad en el espacio durante 30 días, ratones en el espacio sometidos a gravedad artificial simulando la Tierra durante 30 días y un control de ratones en la Tierra.

Se analizaron datos transcriptómicos de RNA-seq obtenidos del BioProject PRJNA1005192 con nueve transcriptomas de hígado paired-end enriquecidas para mRNA Poly(A), secuenciadas con Illumina NovaSeq 6000. Cada condición contó con tres réplicas biológicas y una profundidad de secuenciación de entre 14.4 y 25.9 millones de lecturas, con longitud promedio de 300 pb. Nuestro análisis permitió explorar cambios en la expresión génica relacionados con la adaptación fisiológica hepática frente a condiciones de microgravedad y gravedad artificial.

### Estrutura del repositorio

Este repositorio contiene una estructura diferente a la de de Ken, para observar la documentación de la estrutura de Ken, dirgirse a `Reporte_Equipo3_Rna_seq.qmd`. Las carpetas con su descripción se muestran a continuación

- `figures/`: Este directorio contiene todas las imágenes generadas durante el análisis y la documentación
  - `antes_trimming_multqic_mean_quality.png`: Esta imagen es el resultado del multiqc en la sección mean quality antes de hacer el trimming
  - `antes_trimming_gc_percent.png`: La imagen se refiere al porcentaje de GC en el multiqc antes de hacer el trimming
  - `antes_trimming_q_scores.png`: La imagen representa la distribución de calidades de las secuencias antes de hacer el trimming
  - `antes_trimming_per_base_seq_content.png`: Contiene un gráfico que muestra la proporción de bases A, T, G, C en el multiqc antes de hacer el trimming
  - `antes_trimming_per_base_n_content.png`: Contiene la distribución de bases desconocidas en el multiqc antes de hacer el trimming
  - `antes_trim_sequence_dup_lev.png`: La imagen muestra la distribución de las secuencias duplicadas en el multiqc antes de hacer el trimming
  - `antes_triming_adapters.png`: La imagen muestra la distribución de los adaptadores en el multiqc antes de hacer el trimming
  - `PCA_con_batch_effect.pdf`: Esta imagen es el resultado del PCA con batch effect
  - `PCA_screeplot_con_batch_effect.pdf`: La imagen muestra el scree plot (varianza) del PCA antes de la correción de batch
  - `PCA_screeplot_sin_batch.pdf`: La imagen muestra el scree plot del PCA con la correción de batch
  - `PCA_sin_batch.pdf`: La imagen muestra el PCA sin los efectos del batch
  - `PCA_sin_batch_elipses.pdf`: La imagen muestra el PCA sin los efectos del batch y con los clusters identificados
- `Reporte_Equipo3_Rna_seq.qmd`: Es un archivo .qmd con toda la documentación del análisis, discusión, etc.
- `metadatas.csv`: Este archivo contiene los metadatos del análisis


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


### Referencias

1) Blaber, E. et al. (2017). Spaceflight Activates Autophagy Programs and the Proteasome in Mouse Liver. International Journal of Molecular Sciences

2) Mhatre, S. et al. (2022). Artificial Gravity Partially Protects Space-induced Neurological Deficits in Drosophila melanogaster. Cell Reports

3) Kurosawa R, Sugimoto R, Imai H, Atsuji K, Yamada K, Kawano Y, Ohtsu I, Suzuki K. Impact of spaceflight and artificial gravity on sulfur metabolism in mouse liver: sulfur metabolomic and transcriptomic an>

4) Vinken M. Hepatology in space: Effects of spaceflight and simulated microgravity on the liver. Liver Int. 2022 Dec;42(12):2599-2606. doi: 10.1111/liv.15444. Epub 2022 Oct 12. PMID: 36183343.

