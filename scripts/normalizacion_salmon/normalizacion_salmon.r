.libPaths(c("~/R/libs", .libPaths()))

# Paquetes
library(tximport)
library(DESeq2)
# Definimos la ruta
ruta <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/quality2/salmon"
metadata <- read.csv("/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/metadata.csv", header = TRUE)
metadata$folder_name <- metadata$sample_ID

# Buscamos los quant.sf 
archivos_sf <- file.path(ruta, metadata$folder_name, "quant.sf")

# Extraemos el nombre SRR de la ruta
nombres_srr <- basename(dirname(archivos_sf))
names(archivos_sf) <- nombres_srr
archivos_sf

# Importamos con tximport 
tx2gene <- read.table(
  "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/quality2/salmon/tx2gene.tsv",
  header = FALSE,
  sep    = "\t",
  stringsAsFactors = FALSE
)

tx2gene <- tx2gene[,1:2]

colnames(tx2gene) <- c("TXNAME", "GENEID")

txi.salmon <- tximport(
  archivos_sf,
  type           = "salmon",
  ignoreTxVersion = TRUE,
  ignoreAfterBar  = TRUE,
  tx2gene = tx2gene
)

# Verificamos
names(txi.salmon)

# Imprimimos
all_transcripts <- rownames(txi.salmon$abundance)
length(unique(all_transcripts))

#GUARDAR TXI PARA DESEQ2
outdir <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/"

save(txi.salmon, file = paste0(outdir, "txi_salmon.RData"))
message(" txi.salmon guardado en ", outdir, "txi_salmon.RData")
