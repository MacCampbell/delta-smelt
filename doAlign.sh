#!/bin/bash -l

#Requires a tab delimited list of paired end files (list, $1)
#SRR1613242_1  SRR1613242_2

#Requires a path to indexed reference genome (ref, $2)

#bash ../doAlign.sh tester.txt $HOME/genomes/chinook/GCF_002872995.1_Otsh_v1.0_genomic.fna.gz

list=$1
ref=$2

wc=$(wc -l ${list} | awk '{print $1}')

x=1
while [ $x -le $wc ] 
do
        string="sed -n ${x}p ${list}" 
        str=$($string)

        var=$(echo $str | awk -F"\t" '{print $1, $2}')   
        set -- $var
        c1=$1
        c2=$2

       echo "#!/bin/bash -l
       bwa mem $ref ${c1}.fastq ${c2}.fastq | samtools view -Sb | samtools sort - -o ${c1}.sort.bam
       samtools index ${c1}.sort.bam
       samtools view -f 0x2 -b ${c1}.sort.bam | samtools rmdup - ${c1}.sort.flt.bam
       samtools index ${c1}.sort.flt.bam" > ${c1}.sh
       sbatch -p med -t 4-10:00:00 --mem=8G ${c1}.sh

       x=$(( $x + 1 ))

done


