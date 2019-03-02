#!/bin/bash
#SBATCH --partition=compute
#SBATCH --time=00:01:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --export=ALL
#SBATCH --job-name=mergePeaks
#SBATCH --output=JOB_mergePeaks_%j.out
#SBATCH --error=JOB_mergePeaks_%j.err
#SBATCH --mail-user=ochapman@ucsd.edu
#SBATCH --mail-type=END

######################
# Begin work section #
######################

# $1 path to bed files
# $2 String space-separated list of bed files

module load bedtools
cd $1

echo "Loading peaks..."
echo -n $2 | xargs cat > narrowPeaks.bed
#cat MB*.bed > narrowPeaks.bed

echo "Sorting peaks by chromosome..."
bedtools sort -i narrowPeaks.bed > narrowPeaks.sort.bed

echo "Merging peaks..."
bedtools merge -i narrowPeaks.sort.bed > narrowPeaks.merge.bed

echo "Removing intermediate files..."
rm narrowPeaks.bed
rm narrowPeaks.sort.bed

echo "Converting bed to SAF file for featureCounts annotation..."
awk 'OFS="\t" {print $1":"$2+1"-"$3, $1, $2+1, $3, "."}' narrowPeaks.merge.bed > narrowPeaks.merge.saf

echo "Done."