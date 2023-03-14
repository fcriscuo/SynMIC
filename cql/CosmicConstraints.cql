CREATE CONSTRAINT `imp_uniq_CosmicGeneHallmark_HALLMARK_ID` IF NOT EXISTS
FOR (n: `CosmicGeneHallmark`)
REQUIRE (n.`hallmark_id) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicSample_sample_id` IF NOT EXISTS
FOR (n: `CosmicSample`)
REQUIRE (n.`sample_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicSampleMutationCollection_sample_id` IF NOT EXISTS
FOR (n: `CosmicSampleMutationCollection`)
REQUIRE (n.`sample_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_Patient_id_individual` IF NOT EXISTS
FOR (n: `Patient`)
REQUIRE (n.`id_individual`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_Tumor_id_tumour` IF NOT EXISTS
FOR (n: `Tumor`)
REQUIRE (n.`id_tumour`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicGene_Gene_Symbol` IF NOT EXISTS
FOR (n: `CosmicGene`)
REQUIRE (n.`Gene Symbol`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicGeneMutationCollection_Gene_Symbol` IF NOT EXISTS
FOR (n: `CosmicGeneMutationCollection`)
REQUIRE (n.`Gene Symbol`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicMutation_MUTATION_ID` IF NOT EXISTS
FOR (n: `CosmicMutation`)
REQUIRE (n.`mutation_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicSampleClassification_COSMIC_PHENOTYPE_ID` IF NOT EXISTS
FOR (n: `CosmicSampleClassification`)
REQUIRE (n.`cosmic_phenotype_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicGeneMutationCollection_Gene_Symbol` IF NOT EXISTS
FOR (n: `CosmicGeneMutationCollection`)
REQUIRE (n.`gene_symbol`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicStructuralMutation_MUTATION_ID` IF NOT EXISTS
FOR (n: `CosmicStucturalMutation`)
REQUIRE (n.`mutation_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicSampleMutationCollection_sample_id` IF NOT EXISTS
FOR (n: `CosmicSampleMutationCollection`)
REQUIRE (n.`sample_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicResistanceMutation_MUTATION_ID` IF NOT EXISTS
FOR (n: `CosmicResistanceMutation`)
REQUIRE (n.`identifier`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_SynMIC_SynMIC_ID` IF NOT EXISTS
FOR (n: `SynMIC`)
REQUIRE (n.synmic_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_AltSpliceCancer_id` IF NOT EXISTS
FOR (n: `AltSpliceCancer`)
REQUIRE (n.`id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_HGNC_hgnc_id` IF NOT EXISTS
FOR (n: `HGNC`)
REQUIRE (n.`hgnc_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicBreakpointMutation_IMUTATION_ID` IF NOT EXISTS
FOR (n: `CosmicBreakpointMutation`)
REQUIRE (n.`mutation_id`) IS UNIQUE;

CREATE CONSTRAINT `imp_uniq_CosmicActionability_ID` IF NOT EXISTS
FOR(n:`CosmicActionability`)
REQUIRE (n.`actionability_id`) IS UNIQUE;

// Publication Constraint
CREATE CONSTRAINT `imp_uniq_Publication_pub_id` IF NOT EXISTS
FOR (n: `Publication`)
REQUIRE (n.`pub_id`) IS UNIQUE;

// CosmicCMC Constraint
//MERGE (cmc:CosmicCMC {legacy_mutation_id:nodeRecord.LEGACY_MUTATION_ID})
CREATE CONSTRAINT `imp_uniq_CosmicCMC_legacy_mutation_id` IF NOT EXISTS
FOR (n: `CosmicCMC`)
REQUIRE (n.`legacy_mutation_id`) IS UNIQUE;


CREATE INDEX synmut_gene_symbol_index IF NOT EXISTS FOR (syn:SynonymousMutation) ON (syn.gene_symbol)
CREATE INDEX asc_gene_symbol_index IF NOT EXISTS FOR (asc:ASCancer) ON (asc.gene_symvol)
