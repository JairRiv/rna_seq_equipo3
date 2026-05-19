.libPaths(c("/home/dbarrientos/R/library", .libPaths()))
library(edgeR)
library(DESeq2)
library(tidyverse)
library(cowplot)
library(reshape2)
library(DT)
library(ggplot2)
library(ggrepel)
library(ggforce)
library(apeglm)

outdir <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/"

load(paste0(outdir, "txi_salmon.RData"))
print(colnames(txi.salmon$counts))

sampleTable <- data.frame(condition = factor(rep(c("GC", "A1G", "MG"), each = 3),
                                             levels = c("GC", "A1G", "MG")))
rownames(sampleTable) <- colnames(txi.salmon$counts)
message("sampleTable:")
print(sampleTable)

dds <- DESeqDataSetFromTximport(txi.salmon, sampleTable, ~condition)
print(dds)
dim(dds)

# TPM
tpm <- txi.salmon$abundance
print(head(tpm))
dim(tpm)
write.csv(tpm, file = paste0(outdir, "TPM_matrix.csv"), quote = FALSE)
message("Matriz TPM guardada")

# Crear carpetas
dir.create(paste0(outdir, "processedcounts"), recursive = TRUE, showWarnings = FALSE)
dir.create(paste0(outdir, "counts"), recursive = TRUE, showWarnings = FALSE)
dir.create(paste0(outdir, "DEG"),             recursive = TRUE, showWarnings = FALSE)
# rlog — se aplica al objeto dds
dds <- estimateSizeFactors(dds)
rlog <- rlog(dds, blind = FALSE)
head(assay(rlog))[1:4, 1:4]

# Guardar vrlog
save(rlog, file = paste0(outdir, "processedcounts/rlog.RData"))
message("rlog guardado")

# Raw counts
counts <- counts(dds)
save(counts, file = paste0(outdir, "counts/rawCounts.RData"))
message("rawCounts guardado")

# rlog completo
rlog_all <- rlog(dds, blind = FALSE)
melted_norm_counts <- data.frame(melt(assay(rlog_all)))
colnames(melted_norm_counts) <- c("gene", "sample_ID", "normalized_counts")
save(melted_norm_counts, file = paste0(outdir, "counts/melted_norm_counts.RData"))
save(rlog_all, file = paste0(outdir, "counts/rlog_all.RData"))
message("rlog_all y melted_norm_counts guardados")

# Z-scores
var_non_zero <- apply(counts, 1, var) != 0
filtered_counts <- counts[var_non_zero, ]
zscores <- t(scale(t(filtered_counts)))
dim(zscores)
zscore_mat <- as.matrix(zscores)
save(zscore_mat, file = paste0(outdir, "counts/zscore_mat.RData"))
write.csv(zscore_mat, file = paste0(outdir, "counts/zscore_mat.csv"), row.names = TRUE)
message("zscore_mat guardado")

# PCA
mat <- assay(rlog_all)
pc_wIMQ <- prcomp(t(mat))

variance_explained <- pc_wIMQ$sdev^2 / sum(pc_wIMQ$sdev^2) * 100

pca_df <- data.frame(
  PC1 = pc_wIMQ$x[, 1],
  PC2 = pc_wIMQ$x[, 2],
  condition = sampleTable$condition,
  sample = rownames(sampleTable)
)

# Scree plot
df <- data.frame(
  Componente = seq_along(variance_explained),
  Varianza = variance_explained,
  Etiqueta = paste0("PC", seq_along(variance_explained), ": ", round(variance_explained, 2), "%")
)
 
pdf(paste0(outdir, "PCA_screeplot.pdf"), width = 10, height = 8)
ggplot(df, aes(x = Componente, y = Varianza)) +
  geom_point(color = "darkblue", size = 3) +
  geom_line(color = "darkblue") +
  geom_text_repel(data = df[1:4, ], aes(label = Etiqueta),
                  size = 5, box.padding = unit(0.35, "lines"),
                  point.padding = unit(0.3, "lines"),
                  color = "darkred", fontface = "bold") +
  labs(title = "Scree plot: varianza explicada por PCA",
       x = "Componente principal",
       y = "Porcentaje de varianza explicada") +
  theme_minimal()
dev.off()
message("Scree plot sin batch guardado")



# PCA plot por condicion sin batch (ni elipses)
pdf(paste0(outdir, "PCA_condicion.pdf"), width = 8, height = 6)
ggplot(pca_df, aes(x = PC1, y = PC2, color = condition, label = sample)) +
  geom_point(size = 4) +
  geom_text_repel(size = 3, segment.size = 0) +
  scale_color_manual(values = c("GC" = "salmon", "A1G" = "steelblue", "MG" = "purple")) +
  xlab(paste0("PC1: ", round(variance_explained[1], 1), "% varianza")) +
  ylab(paste0("PC2: ", round(variance_explained[2], 1), "% varianza")) +
  ggtitle("PCA sin correccion de batch") +
  theme_cowplot()
dev.off()
message("PCA sin batch guardado")

#limma correcciobn batch

library(limma)
print(colnames(assay(rlog_all)))
batch <- factor(c(1,1,1, 1,1,1, 2,2,2))

mat <- assay(rlog_all)
mm <- model.matrix(~1, colData(rlog_all))
mat_corrected <- limma::removeBatchEffect(mat, batch=rlog_all$batch, design=mm)
assay(rlog_all) <- mat_corrected


pcaData <- plotPCA(rlog_all, intgroup = "condition", returnData = TRUE)
percentVar <- round(100 * attr(pcaData, "percentVar"))
pc_all <- prcomp(t(mat))
variance_explained <- pc_all$sdev^2 / sum(pc_all$sdev^2) * 100

pdf(paste0(outdir, "PCA_sin_batch.pdf"), width = 8, height = 6)
ggplot(pcaData, aes(PC1, PC2, color = condition, label = name)) +
  geom_point(size = 4) +
  geom_text_repel(size = 3, max.overlaps = 20) +
  scale_color_manual(values = c("GC" = "salmon", "A1G" = "steelblue", "MG" = "purple")) +
  scale_fill_manual(values = c("GC" = "salmon", "A1G" = "steelblue", "MG" = "purple")) +
  xlab(paste0("PC1: ", percentVar[1], "% varianza")) +
  ylab(paste0("PC2: ", percentVar[2], "% varianza")) +
  ggtitle("PCA con correccion de batch") +
  coord_fixed() +
  theme_cowplot()+
  theme(legend.position = "right")
dev.off()
message("PCA sin batch guardado")

head(rlog$batch)

# Scree plot sin batch effect
df <- data.frame(
	  Componente = seq_along(variance_explained),
  Varianza = variance_explained,
  Etiqueta = paste0("PC", seq_along(variance_explained), ": ", round(variance_explained, 2), "%")
)

pdf(paste0(outdir, "PCA_screeplot_sin_batch.pdf"), width = 10, height = 8)
ggplot(df, aes(x = Componente, y = Varianza)) +
  geom_point(color = "darkblue", size = 3) +
  geom_line(color = "darkblue") +
  geom_text_repel(data = df[1:4, ], aes(label = Etiqueta),
                  size = 5, box.padding = unit(0.35, "lines"),
                  point.padding = unit(0.3, "lines"),
                  color = "darkred", fontface = "bold") +
  labs(title = "Scree plot: varianza explicada por PCA",
       x = "Componente principal",
       y = "Porcentaje de varianza explicada") +
  theme_minimal()
dev.off()
message("Scree plot sin batch effect guardado")


#matriz corregida

write.csv(mat_corrected, 
          file = paste0(outdir, "counts/mat_corrected.csv"), 
          row.names = TRUE)
save(mat_corrected, 
     file = paste0(outdir, "counts/mat_corrected.RData"))
message("Matriz sin batch effect guardada")



## Pca con elipses

pdf(paste0(outdir, "PCA_sin_batch_elipses.pdf"), width = 8, height = 6)
ggplot(pcaData, aes(PC1, PC2, color = condition, fill = condition, label = name)) +
  geom_mark_hull(
    aes(group = condition, label = NA),
    linewidth = 0.5,
    alpha = 0.15,
    show.legend = FALSE,
    concavity = 2,
    expand = unit(2, "mm"),
    radius = unit(2, "mm"),
  ) +
  geom_point(size = 4) +
  geom_text_repel(size = 3, max.overlaps = 20, segment.size = 0) +
  scale_color_manual(values = c("GC" = "salmon", "A1G" = "steelblue", "MG" = "purple")) +
  scale_fill_manual(values = c("GC" = "salmon", "A1G" = "steelblue", "MG" = "purple"), guide = "none") +
  xlab(paste0("PC1: ", percentVar[1], "% varianza")) +
  ylab(paste0("PC2: ", percentVar[2], "% varianza")) +
  ggtitle("PCA con correccion de batch") +
  coord_fixed() +
  theme_cowplot() +
  theme(legend.position = "right")
dev.off()
message("PCA con batch elipses guardado")


cat("\n=== Corriendo analisis de expresion diferencial ===\n")
 
dds <- DESeq(dds)
 
cat("Coeficientes disponibles:\n")
print(resultsNames(dds))
# Esperado: "Intercept", "batch_2_vs_1", "condition_A1G_vs_GC", "condition_MG_vs_GC", "condition_A1G_vs_MG"
 
# --- A1G vs GC (referencia) ---
cat("\nCalculando: A1G vs GC\n")
res_A1G_vs_GC <- lfcShrink(
  dds,
  coef = "condition_A1G_vs_GC",
  type = "apeglm"
)
summary(res_A1G_vs_GC)
write.csv(as.data.frame(res_A1G_vs_GC),
          file = paste0(outdir, "DEG/DEG_A1G_vs_GC.csv"),
          row.names = TRUE)
save(res_A1G_vs_GC, file = paste0(outdir, "DEG/res_A1G_vs_GC.RData"))
message("DEG A1G vs GC guardado")
 
# --- MG vs GC (referencia) ---
cat("\nCalculando: MG vs GC\n")
res_MG_vs_GC <- lfcShrink(
  dds,
  coef = "condition_MG_vs_GC",
  type = "apeglm"
)
summary(res_MG_vs_GC)
write.csv(as.data.frame(res_MG_vs_GC),
          file = paste0(outdir, "DEG/DEG_MG_vs_GC.csv"),
          row.names = TRUE)
save(res_MG_vs_GC, file = paste0(outdir, "DEG/res_MG_vs_GC.RData"))
message("DEG MG vs GC guardado")
 
# -- A1G vs MG(espacio)

cat("\nCalculando: MG vs A1G\n")
res_MG_vs_A1G <- lfcShrink(
  dds,
  contrast = c("condition", "MG", "A1G"),
  type = "ashr"          # ashr acepta contrasts arbitrarios
)
summary(res_MG_vs_A1G)
write.csv(as.data.frame(res_MG_vs_A1G),
          file = paste0(outdir, "DEG/DEG_MG_vs_A1G.csv"),
          row.names = TRUE)
save(res_MG_vs_A1G, file = paste0(outdir, "DEG/res_MG_vs_A1G.RData"))
message("DEG MG vs A1G guardado")
 

filter_DEG <- function(res, label) {
  df <- as.data.frame(res) %>%
    rownames_to_column("gene") %>%
    filter(!is.na(padj), padj < 0.05, abs(log2FoldChange) > 1) %>%
    arrange(padj)
  cat(sprintf("\n%s: %d genes significativos (padj<0.05, |LFC|=>2)\n", label, nrow(df)))
  return(df)
}
 
sig_A1G_vs_GC  <- filter_DEG(res_A1G_vs_GC,  "A1G vs GC")
sig_MG_vs_GC   <- filter_DEG(res_MG_vs_GC,   "MG vs GC")
sig_MG_vs_A1G  <- filter_DEG(res_MG_vs_A1G,  "MG vs A1G")
 
write.csv(sig_A1G_vs_GC,  paste0(outdir, "DEG/SIG_A1G_vs_GC.csv"),  row.names = FALSE)
write.csv(sig_MG_vs_GC,   paste0(outdir, "DEG/SIG_MG_vs_GC.csv"),   row.names = FALSE)
write.csv(sig_MG_vs_A1G,  paste0(outdir, "DEG/SIG_MG_vs_A1G.csv"),  row.names = FALSE)
message("Tablas de genes significativos guardadas en DEG/")
 
cat("\n=== Analisis de expresion diferencial completado ===\n")
