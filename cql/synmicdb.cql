
:auto LOAD CSV WITH HEADERS FROM
'file:///Volumes/SSD870/SpecializedCancerDatasets/SynMICdb/SynMICdb.csv' AS line

 CALL {
WITH line
MERGE (syn:SynonymousMutation:Mutation{synonymous_id:apoc.create.uuid()})
SET syn.gene_symbol=line.`Gene Name`,
  syn.mutation_id=line.`Mutation ID`,
  syn.transcript_id=line.`Transcript ID`,
  syn.mutation_nt=line.`Mutation nt`,
  syn.mutation_aa=line.`Mutation aa`,
  syn.mutation_genome_position=line.`Mutation Genome Position`,
  syn.chromosome=line.Chromosome,
  syn.mutation_start=toInteger(line.Start),
  syn.mutation_end=toInteger(line.End),
  syn.mutation_strand=line.Strand,
  syn.signature_norm_freq=toFloat(line.`Signature-normalized Frequency`),
  syn.avg_mutation_load=toInteger(line.`Average Mutation Load`),
  syn.alternative_events=split(line.`Alternative Events`,' '),
  syn.SNP=toUpper(line.SNP),
  syn.conservation=toFloat(line.Conservation),
  syn.structure_change_score_remuRNA=toFloat(line.`Structure Change Score (remuRNA)`),
  syn.structure_change_significance_RNAsnp=toFloat(line.`Structure Change Significance (RNAsnp)`),
  syn.SynMICdb_score=line.`SynMICdb Score`,
  syn.sample_name=line.`Sample ID`,
  syn.organ_system=line.`Organ System`,
  syn.site=line.Site,
  syn.histology=line.Histology,
  syn.mutation_load_sample=toInteger(line.`Mutation Load Sample`),
  syn.position_in_cds=toFloat(line.`Position in CDS`),
  syn.cgc_gene=toInteger(line.`CGC Gene`),
  syn.exon_type=toInteger(line.`Exon Type`),
  syn.dist_to_exon_boundary=toInteger(line.`Distance to Closest Exon Boundary`),
  syn.ese_gain_regrna_2=toInteger(line.`ESE Gain (RegRNA 2.0)`),
  syn.ese_loss_regrna_2=toInteger(line.`ESE Loss (RegRNA 2.0)`),
  syn.ess_gain_regrna_2=toInteger(line.`ESS Gain (RegRNA 2.0)`),
  syn.ess_loss_regrna_2=toInteger(line.`ESS Loss (RegRNA 2.0)`),
  syn.ese_gain_spliceadf=toInteger(line.`ESE Gain (SpliceAidF)`),
  syn.ese_loss_spliceadf=toInteger(line.`ESE Loss (SpliceAidF)`),
  syn.ess_gain_spliceadf=toInteger(line.`ESS Gain (SpliceAidF)`),
  syn.ess_loss_spliceadf=toInteger(line.`ESS Loss (SpliceAidF`),
  syn.ess_ese_gain_spliceadf=toInteger(line.`ESE & ESS Gain (SpliceAidF)`),
  syn.ess_ese_loss_spliceadf=toInteger(line.`ESE & ESS Loss (SpliceAidF)`),
  syn.any_ess_ese_change=toInteger(line.`Any ESE/ESS Change`),
  syn.date_created=datetime()
}IN TRANSACTIONS OF 3000 ROWS;

MATCH (syn:SynonymousMutation) WHERE syn.gene_symbol IS NOT NULL
MATCH (gmc:GeneMutationCollection) WHERE gmc.gene_symbol = syn.gene_symbol
MERGE (gmc)-[HAS_SYNONYMOUS_MUTATION]->(syn)
;

MATCH (syn:SynonymousMutation) WHERE syn.sample_name IS NOT NULL
MATCH(cs:CosmicSample) WHERE cs.sample_name = syn.sample_name
MATCH (smc:SampleMutationCollection) WHERE smc.sample_id = cs.sample_id
MERGE (smc)-[HAS_SYNONYMOUS_MUTATION]->(syn)
;
