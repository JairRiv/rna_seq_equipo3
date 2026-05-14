# Documentacion del proyecto: Impact of spaceflight and artificial gravity on sulfur metabolism in mouse liver: sulfur metabolomic and transcriptomic analysis
**Fecha de entrega: 20 de Mayo del 2025**
**Bioinformatica y estadistica 2**

### Elaborado por:

-⁠ ⁠Equipo: 3

-⁠ ⁠Integrantes:

• Diana Barrientos González (dbarrientos): [diana.barrientos.glz\@gmail.com](mailto:diana.barrientos.glz@gmail.com)

• Román Cervantes Levario (rcervantes): [ro.cerlev\@gmail.com](mailto:ro.cerlev@gmail.com)

• Jair Emiliano Contreras Rivera (jcontreras): [jairivera322\@gmail.com](mailto:jairivera322@gmail.com)

### Abstract
Para este análisis de RNA-seq, se utilizaron datos de un estudio que compara transcriptomas hepáticos de ratones bajo tres condiciones diferentes: ratones expuestos a gravedad artificial en la Tierra, ratones sometidos a microgravedad en el espacio durante 30 días y un control de ratones en la Tierra.

Se analizaron datos transcriptómicos de RNA-seq obtenidos del BioProject PRJNA1005192 con nueve transcriptomas de hígado paired-end enriquecidas para mRNA Poly(A), secuenciadas con Illumina NovaSeq 6000. Cada condición contó con tres réplicas biológicas y una profundidad de secuenciación de entre 14.4 y 25.9 millones de lecturas, con longitud promedio de 300 pb. Nuestro análisis permitió explorar cambios en la expresión génica relacionados con la adaptación fisiológica hepática frente a condiciones de microgravedad y gravedad artificial.

### Estrutura del repositorio

Este repositorio contiene una estrutrua diferente a la de de Ken, para observar la documentacion de la estrutura de Ken, dirgirse a `Reporte_Equipo3_Rna_seq.qmd`. Las carpetas con su descripcion se muestran a continuación

- `figures/`: Este directorio contiene todas las imagenes generadas durante el analisis y la documentación
  - `antes_trimming_multqic_mean_quality.png`: Esta imagen es el resultado del multiqc en la seeccion mean quality antes de hacer el trimming
  - `antes_trimming_gc_percent.png`: La imagen se refiere a el porcentaje de GC en el multiqc antes de hacer el trimming
  - `antes_trimming_q_scores.png`: La imagen representa la distribucion de calidades de las secuencias antes de hacer el trimming
  - `antes_trimming_per_base_seq_content.png`: Contiene un grafico que muestra la proporcion de bases A, T, G, C en el multiqc antes de hacer el trimming
  - `antes_trimming_per_base_n_content.png`: Contiene la distribucion de bases desconocidas en el multiqc antes de hacer el trimming
  - `antes_trim_sequence_dup_lev.png`: La imagen muestra la distribucion de las secuencias duplicadas en el multiqc antes de hacer el trimming
  - `antes_triming_adapters.png`: La imagen muestra la distribucion de los adapatadores en el multqc antes de hacer el trimming
  - `PCA_con_batch_effect.pdf`: Esta imagen es el resultado del PCA con batch effect
  - `PCA_screeplot_con_batch_effect.pdf`: La imagen muestra el scree plot (varianza) de el PCA antes de la correcion de batch
  - `PCA_screeplot_sin_batch.pdf`: La imagen muestra el scree plot de el PCA con la correcion de batch
  - `PCA_sin_batch.pdf`: La imagen muestra el PCA con sin los efectos del batch

- `Reporte_Equipo3_Rna_seq.qmd`: Es un archivo .qmd con toda la documentación del analisis, discusion, etc.
- `metadatas.csv`: Este archivo contiene los metadatos del analisis


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


