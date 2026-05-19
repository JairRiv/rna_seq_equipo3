#!/bin/bash
#SBATCH --job-name=DownloadData
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/DownloadData_%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw/DownloadData_%j.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8        # ← subimos a 8 núcleos para el paralelo
#SBATCH --mem=4G                 # ← un poco más por si acaso
#SBATCH --mail-type=END
#SBATCH --mail-user=diana.barrientos.glz@gmail.com

. /etc/profile.d/modules.sh

cd /mnt/data/bioinfo-estadistica-2/RNAseq_2026/equipos/Equipo3/data/raw

# Lista de URLs a descargar
URLS=(
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/068/SRR25629468/SRR25629468_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/068/SRR25629468/SRR25629468_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/073/SRR25629473/SRR25629473_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/073/SRR25629473/SRR25629473_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/067/SRR25629467/SRR25629467_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/067/SRR25629467/SRR25629467_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/070/SRR25629470/SRR25629470_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/070/SRR25629470/SRR25629470_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/071/SRR25629471/SRR25629471_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/071/SRR25629471/SRR25629471_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/065/SRR25629465/SRR25629465_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/065/SRR25629465/SRR25629465_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/066/SRR25629466/SRR25629466_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/066/SRR25629466/SRR25629466_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/069/SRR25629469/SRR25629469_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/069/SRR25629469/SRR25629469_2.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/072/SRR25629472/SRR25629472_1.fastq.gz
  ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR256/072/SRR25629472/SRR25629472_2.fastq.gz
)

# Función de descarga con reintentos
download() {
  local url=$1
  local file=$(basename "$url")
  if [[ -f "$file" ]]; then
    echo "[SKIP] $file ya existe"
    return
  fi
  echo "[START] $file"
  wget -q --tries=3 --waitretry=5 -O "$file" "$url" \
    && echo "[OK] $file" \
    || echo "[FAIL] $file"
}

export -f download

# Lanza hasta 6 descargas simultáneas
printf '%s\n' "${URLS[@]}" | xargs -P 6 -I {} bash -c 'download "$@"' _ {}

echo "¡Todas las descargas terminaron!"
