.libPaths(c("/home/dbarrientos/R/library", .libPaths()))
options(repos = c(CRAN = "https://cran.r-project.org"))
 
# libraries
library(gprofiler2)
library(enrichplot)
library(DOSE)
library(clusterProfiler)
library(ggplot2)
library(tidyverse)
library(dplyr)
library(org.Mm.eg.db)  # raton, en lugar de org.Hs.eg.db
 
# directory
deg_dir <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/DEG/"
outdir  <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/ORA/"
figdir  <- "/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/ORA/figures/"
 
dir.create(outdir,  recursive = TRUE, showWarnings = FALSE)
dir.create(figdir,  recursive = TRUE, showWarnings = FALSE)
# Bases de datos para ORA
sources_db <- c("GO:BP", "KEGG", "REAC", "WP")
 
# coloresss
Category_colors <- data.frame(
  category = c("GO:BP", "GO:CC", "GO:MF", "KEGG", "REAC", "WP"),
  label    = c("Biological Process", "Cellular Component", "Molecular Function",
               "KEGG", "Reactome", "WikiPathways"),
  colors   = c("#FF9900", "#109618", "#DC3912", "#DD4477", "#3366CC", "#0099C6")
)
 

#ORA y plots para una comparacion
run_ora <- function(deg_file, comp_name) {
 
  cat("\n====", comp_name, "====\n")
 
  # Cargar resultados DESeq2
  df <- read.csv(deg_file, row.names = 1)
 
  # Clasificar genes por expresion (LFC =>2, padj < 0.05)
  abslogFC <- 1
  df <- df %>%
    dplyr::mutate(Expression = case_when(
      log2FoldChange >= abslogFC  & padj < 0.05 ~ "Up-regulated",
      log2FoldChange <= -abslogFC & padj < 0.05 ~ "Down-regulated",
      TRUE ~ "Unchanged"
    ))
 
  up_genes   <- df %>% filter(Expression == "Up-regulated") %>%
    arrange(padj, desc(abs(log2FoldChange))) %>% rownames()
  down_genes <- df %>% filter(Expression == "Down-regulated") %>%
    arrange(padj, desc(abs(log2FoldChange))) %>% rownames()
 
  cat("Up-regulated:", length(up_genes), "genes\n")
  cat("Down-regulated:", length(down_genes), "genes\n")
 
  if (length(up_genes) == 0 & length(down_genes) == 0) {
    cat("Sin genes significativos para", comp_name, "— saltando\n")
    return(invisible(NULL))
  }
 
  #  gost ORA
  query_list <- list()
  if (length(up_genes)   > 0) query_list[["Upregulated"]]   <- up_genes
  if (length(down_genes) > 0) query_list[["Downregulated"]] <- down_genes
 
  multi_gp <- gost(
    query_list,
    correction_method = "fdr",
    user_threshold    = 0.05,
    multi_query       = FALSE,
    ordered_query     = TRUE,
    sources           = sources_db,
    evcodes           = TRUE,
    organism          = "mmusculus"
  )
 
  if (is.null(multi_gp)) {
    cat("gost no devolvio resultados para", comp_name, "\n")
    return(invisible(NULL))
  }
 
  # Manhattan plot
  gostp1 <- gostplot(multi_gp, interactive = FALSE)
  ggsave(paste0(figdir, "ManhattanGO_", comp_name, ".pdf"),
         plot = gostp1, width = 12, height = 6)
  message("Manhattan plot guardado: ", comp_name)
 
  #  dataframe comun
  gost_query <- as.data.frame(multi_gp$result)
 

  #coll 
list_cols <- sapply(gost_query, is.list)
  gost_query[list_cols] <- lapply(gost_query[list_cols], function(col) {
    sapply(col, paste, collapse = ",")
  })
 
  bar_data <- data.frame(
    term      = as.factor(gost_query$term_name),
    condition = gost_query$query,
    count     = gost_query$term_size,
    p.adjust  = gost_query$p_value,
    category  = as.factor(gost_query$source),
    go_id     = as.factor(gost_query$term_id),
    geneNames = gost_query$intersection
  )
 
  # Guardar resultado completo
  write.csv(bar_data, paste0(outdir, "ORA_full_", comp_name, ".csv"), row.names = FALSE)
 
  # Funcion barplot (UP o DOWN)
  make_barplot <- function(bar_subset, direction) {
 
    if (nrow(bar_subset) == 0) {
      cat("Sin terminos", direction, "para", comp_name, "\n")
      return(invisible(NULL))
    }
 
    bar_ordered <- bar_subset %>%
      arrange(p.adjust) %>%
      head(40) %>%
      arrange(category) %>%
      mutate(
        p.val = round(-log10(p.adjust), 2),
        num   = seq_len(n())
      )
 
    write.csv(bar_ordered,
              paste0(outdir, direction, "_GO_", comp_name, ".csv"),
              row.names = FALSE)
 
    bar_mod <- left_join(bar_ordered, Category_colors, by = "category")
 
    # orden en colors y label
    fill_labels <- bar_mod %>% distinct(category, label, colors) %>% arrange(category)
 
    g <- ggplot(bar_mod, aes(p.val, reorder(term, -num), fill = category)) +
      geom_bar(stat = "identity") +
      geom_text(aes(label = p.val), color = "black", hjust = 0,
                size = 2.2, position = position_dodge(0)) +
      labs(
        title = paste0(direction, " — ", comp_name),
        x     = "-log10(p-value)",
        y     = NULL
      ) +
      scale_fill_manual(
        name   = "Category",
        labels = fill_labels$label,
        values = setNames(fill_labels$colors, fill_labels$category)
      ) +
      theme_classic() +
      theme(
        legend.position = "right",
        axis.title.y    = element_blank(),
        plot.title      = element_text(face = "bold")
      )
 
    ggsave(paste0(figdir, "barplot", direction, "_GO_", comp_name, ".pdf"),
           plot = g, dpi = 600, width = 10, height = 6)
    message("Barplot ", direction, " guardado: ", comp_name)
  }
 
  make_barplot(subset(bar_data, condition == "Upregulated"),   "UP")
  make_barplot(subset(bar_data, condition == "Downregulated"), "DOWN")
 
  #  KEGG enrichment con clusterProfiler
  deg_genes    <- df %>% filter(Expression != "Unchanged")
  gene_symbols <- rownames(deg_genes)
 
  gene_entrez <- tryCatch(
    bitr(gene_symbols, fromType = "SYMBOL", toType = "ENTREZID", OrgDb = org.Mm.eg.db),
    error = function(e) { cat("bitr fallo para", comp_name, "\n"); NULL }
  )
 
  if (!is.null(gene_entrez) && nrow(gene_entrez) > 0) {
 
    kegg_res <- enrichKEGG(
      gene          = gene_entrez$ENTREZID,
      organism      = "mmu",          # raton
      pvalueCutoff  = 1,
      pAdjustMethod = "fdr"
    )
 
    kegg_df <- as.data.frame(kegg_res) %>%
      mutate(
        S           = as.integer(sub("/.*", "", GeneRatio)),
        B           = as.integer(sub("/.*", "", BgRatio)),
        Rich_Factor = round(S / B, 4)
      ) %>%
      rowwise() %>%
      mutate(
        gene_symbols_col = {
          ids  <- strsplit(geneID, "/")[[1]]
          syms <- tryCatch(
            bitr(ids, fromType = "ENTREZID", toType = "SYMBOL", OrgDb = org.Mm.eg.db),
            error = function(e) data.frame(SYMBOL = ids)
          )
          paste(syms$SYMBOL, collapse = ", ")
        }
      ) %>%
      ungroup() %>%
      dplyr::select(
        `Pathway ID`   = ID,
        `Pathway Name` = Description,
        S, B,
        `Rich Factor`  = Rich_Factor,
        `P value`      = pvalue,
        Genes          = gene_symbols_col
      ) %>%
      filter(`P value` < 0.05) %>%
      arrange(`P value`)
 
    write.csv(kegg_df,
              paste0(outdir, "KEGG_enrichment_", comp_name, ".csv"),
              row.names = FALSE)
 
    # Dotplot KEGG
    if (nrow(kegg_df) > 0) {
      plot_data <- kegg_df %>%
        arrange(`P value`) %>%
        mutate(
          `Pathway Name` = stringr::str_wrap(`Pathway Name`, width = 25)
        )
 
      dotplot_kegg <- ggplot(plot_data,
                             aes(x = `Rich Factor`,
                                 y = reorder(`Pathway Name`, `Rich Factor`),
                                 color = `P value`,
                                 size  = S)) +
        geom_point() +
        scale_color_gradient(low = "#d73027", high = "#4575b4", name = "P-value") +
        scale_size_continuous(name = "Gene count", range = c(3, 8)) +
        labs(title = paste("KEGG Pathway Enrichment —", comp_name),
             x = "Rich Factor", y = NULL) +
        theme_dose() +
        theme(
          axis.text.y     = element_text(size = 9),
          plot.title      = element_text(hjust = 0.5, face = "bold"),
          legend.position = "right"
        )
 
      ggsave(paste0(figdir, "KEGG_dotplot_", comp_name, ".pdf"),
             plot = dotplot_kegg, width = 10, height = 7)
      message("KEGG dotplot guardado: ", comp_name)
    }
  }
}
 
# 
# comparaciones
comparaciones <- list(
  list(file = paste0(deg_dir, "DEG_A1G_vs_GC.csv"),  name = "A1G_vs_GC"),
  list(file = paste0(deg_dir, "DEG_MG_vs_A1G.csv"),  name = "MG_vs_A1G"),
  list(file = paste0(deg_dir, "DEG_MG_vs_GC.csv"),   name = "MG_vs_GC")
)
 
for (comp in comparaciones) {
  run_ora(comp$file, comp$name)
}
 
cat("\n=== Analisis GO y KEGG completado ===\n")
cat("Figuras en:", figdir, "\n")
cat("Tablas en:", outdir, "\n")
 
