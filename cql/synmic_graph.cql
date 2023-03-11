CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/Cancer_Gene_Census_Hallmarks_Of_Cancer.tsv", { header:true,  sep:"TAB"})
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
',' 

  ',
{batchSize:1000, iterateList:true, parallel:true});


CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/Cancer_Gene_Census_Hallmarks_Of_Cancer.tsv", { header:true,  sep:"TAB"})
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT nodeRecord.`GENE_NAME` IS  NULL
MERGE (n: `TestHallmark` { `HALLMARK_ID`: toInteger(lineNo) })
SET n.`gene_symbol` = nodeRecord.`GENE_NAME`
SET n.`cell_type` = nodeRecord.`CELL_TYPE`
SET n.`pub_id` = toInteger(trim(nodeRecord.`PUBMED_PMID`))
SET n.`hallmark` = nodeRecord.`HALLMARK`
SET n.`impact` = nodeRecord.`IMPACT`
SET n.`description` = nodeRecord.`DESCRIPTION`
',
{batchSize:1000, iterateList:true, parallel:true});


CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicSample.tsv", { header:true,  sep:"TAB"})
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
',' 
WHERE NOT toInteger(trim(nodeRecord.`sample_id`)) IS NULL
MERGE (n: `CosmicSample` { `sample_id`: toInteger(trim(nodeRecord.`sample_id`)) })
SET n.`sample_name` = nodeRecord.`sample_name`
SET n.`therapy_relationship` = nodeRecord.`therapy_relationship`
SET n.`sample_differentiator` = nodeRecord.`sample_differentiator`
SET n.`mutation_allele_specification` = nodeRecord.`mutation_allele_specification`
SET n.`msi` = nodeRecord.`msi`
SET n.`whole_genome_screen` = nodeRecord.`whole_genome_screen`
SET n.`whole_exome_screen` = nodeRecord.`whole_exome_screen`
SET n.`sample_remark` = nodeRecord.`sample_remark`
SET n.`germline_mutation` = nodeRecord.`germline_mutation`
SET n.`sample_type` = nodeRecord.`sample_type`
SET n.`cosmic_phenotype_id` = toInteger(trim(nodeRecord.`cosmic_phenotype_id`));
 ',
{batchSize:1000, iterateList:true, parallel:true});

CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicSample.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`id_individual`)) IS NULL
MERGE (n: `Patient` { `id_individual`: toInteger(trim(nodeRecord.`id_individual`)) })
SET n.`metastatic_site` = nodeRecord.`metastatic_site`
SET n.`age` = toInteger(trim(nodeRecord.`age`))
SET n.`ethnicity` = nodeRecord.`ethnicity`
SET n.`environmental_variables` = nodeRecord.`environmental_variables`
SET n.`therapy` = nodeRecord.`therapy`
SET n.`family` = nodeRecord.`family`
SET n.`normal_tissue_tested` = nodeRecord.`normal_tissue_tested`
SET n.`individual_remark` = nodeRecord.`individual_remark`
SET n.`gender` = nodeRecord.`gender`;
 ',
{batchSize:1000, iterateList:true, parallel:true});


CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicSample.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`id_tumour`)) IS NULL
MERGE (n: `Tumor` { `id_tumour`: toInteger(trim(nodeRecord.`id_tumour`)) })
SET n.`drug_response` = nodeRecord.`drug_response`
SET n.`grade` = nodeRecord.`grade`
SET n.`age_at_tumour_recurrence` = nodeRecord.`age_at_tumour_recurrence`
SET n.`stage` = nodeRecord.`stage`
SET n.`nci_code` = nodeRecord.`nci_code`;
',
{batchSize:1000, iterateList:true, parallel:true});


CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/cancer_gene_census.csv", { header:true,
mapping:{
     `Tumour Types(Somatic)`: {array:true, arraySep:",", name:"tumor_types_somatic"},
     `Tumour Types(Germline)`: {array:true, arraySep:",", name:"tumor_types_germline"},
     `Translocation Partner`: {array:true, arraySep:",", name:"translocation_partners"},
      `Mutation Types`: {array:true, arraySep:",", name:"mutation_types"},
      `Other Syndrome`: {array:true, arraySep:",", name:"other_syndromes"},
     Synonyms: {array:true, arraySep:",", name:"synonyms"}
   }
}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT nodeRecord.`Gene Symbol` IS NULL
MERGE (n: `CosmicGene` { gene_symbol: nodeRecord.`Gene Symbol` })
SET n.`gene_name` = nodeRecord.`Name`
SET n.`entrez_gene_id` = toInteger(trim(nodeRecord.`Entrez GeneId`))
SET n.`genome_location` = nodeRecord.`Genome Location`
SET n.`tier` = toInteger(trim(nodeRecord.`Tier`))
SET n.`hallmark` = nodeRecord.`Hallmark`
SET n.`chr_band` = toFloat(trim(nodeRecord.`Chr Band`))
SET n.`somatic` = nodeRecord.`Somatic`
SET n.`germline` = nodeRecord.`Germline`
SET n.`tumor_types_somatic` = nodeRecord.`tumor_types_somatic`
SET n.`tumor_types_germline` = nodeRecord.`tumor_types_germline`
SET n.`cancer_syndrome` = nodeRecord.`Cancer Syndrome`
SET n.`tissue_type` = nodeRecord.`Tissue Type`
SET n.`molecular_genetics` = nodeRecord.`Molecular Genetics`
SET n.`role_in_cancer` = nodeRecord.`Role in Cancer`
SET n.`mutation_types` = nodeRecord.`mutation_types`
SET n.`translocation_partners` = nodeRecord.`translocation_partners`
SET n.`other_germline_mut` = nodeRecord.`Other Germline Mut`
SET n.`other_syndromes` = nodeRecord.`other_syndromes`
SET n.`cosmic_id` = nodeRecord.`COSMIC ID`
SET n.`cosmic gene name` = nodeRecord.`cosmic gene name`
SET n.`synonyms` = nodeRecord.synonyms;
',
{batchSize:1000, iterateList:true, parallel:true});


// CosmicMutation
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicMutantExportCensus.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE  toInteger(trim(nodeRecord.`MUTATION_ID`)) IS NULL
MERGE (n: `CosmicMutation` { `mutation_id`: toInteger(trim(nodeRecord.`MUTATION_ID`)) })
SET n.`gene_symbol` = nodeRecord.`Gene name`
SET n.`accession_number` = nodeRecord.`Accession Number`
SET n.`cds_length` = toInteger(trim(nodeRecord.`Gene CDS length`))
SET n.`hgnc_id` = toInteger(trim(nodeRecord.`HGNC ID`))
SET n.`sample_name` = nodeRecord.`Sample name`
SET n.`sample_id` = toInteger(trim(nodeRecord.`ID_sample`))
SET n.`tumor_id` = toInteger(trim(nodeRecord.`ID_tumour`))
SET n.`primary_site` = nodeRecord.`Primary site`
SET n.`primary_histology` = nodeRecord.`Primary histology`
SET n.`genome_screen` = nodeRecord.`Genome-wide screen`
SET n.`genomic_mutation_id` = nodeRecord.`GENOMIC_MUTATION_ID`
SET n.`legacy_mutation_id` = nodeRecord.`LEGACY_MUTATION_ID`
SET n.`mutation_cds` = nodeRecord.`Mutation CDS`
SET n.`mutation_aa` = nodeRecord.`Mutation AA`
SET n.`mutation_description` = nodeRecord.`Mutation Description`
SET n.`Mutation zygosity` = nodeRecord.`Mutation zygosity`
SET n.`LOH` = nodeRecord.`LOH`
SET n.`GRCh` = toInteger(trim(nodeRecord.`GRCh`))
SET n.`mutation_genome_position` = nodeRecord.`Mutation genome position`
SET n.`mutation_strand` = nodeRecord.`Mutation strand`
SET n.`resistance_mutation` = nodeRecord.`Resistance Mutation`
SET n.`mutation_somatic_status` = nodeRecord.`Mutation somatic status`
SET n.`pub_id` = toInteger(trim(nodeRecord.`Pubmed_PMID`))
SET n.`study_id` = toInteger(trim(nodeRecord.`ID_STUDY`))
SET n.`sample_type` = nodeRecord.`Sample Type`
SET n.`tumor_origin` = nodeRecord.`Tumour origin`
SET n.`Age` = toFloat(trim(nodeRecord.`Age`))
SET n.`tier` = toInteger(trim(nodeRecord.`Tier`))
SET n.`HGVSP` = nodeRecord.`HGVSP`
SET n.`HGVSC` = nodeRecord.`HGVSC`
SET n.`HGVSG` = nodeRecord.`HGVSG`;
',
{batchSize:1000, iterateList:true, parallel:true});

// CosmicSampleClassification

CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/classification.csv", { header:true}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT nodeRecord.`COSMIC_PHENOTYPE_ID` IS NULL
MERGE (n: `CosmicSampleClassification` { `cosmic_phenotype_id`: nodeRecord.`COSMIC_PHENOTYPE_ID` })
SET n.`site_primary` = nodeRecord.`SITE_PRIMARY`
SET n.`site_subtype1` = nodeRecord.`SITE_SUBTYPE1`
SET n.`site_subtype2` = nodeRecord.`SITE_SUBTYPE2`
SET n.`site_subtype33` = nodeRecord.`SITE_SUBTYPE3`
SET n.`histology` = nodeRecord.`HISTOLOGY`
SET n.`hist_subtype1` = nodeRecord.`HIST_SUBTYPE1`
SET n.`hist_subtype2` = nodeRecord.`HIST_SUBTYPE2`
SET n.`hist_subtype3` = nodeRecord.`HIST_SUBTYPE3`
SET n.`site_primary_cosmic` = nodeRecord.`SITE_PRIMARY_COSMIC`
SET n.`site_subtype1_cosmic` = nodeRecord.`SITE_SUBTYPE1_COSMIC`
SET n.`site_subtype2_cosmic` = nodeRecord.`SITE_SUBTYPE2_COSMIC`
SET n.`site_subtype3_cosmic` = nodeRecord.`SITE_SUBTYPE3_COSMIC`
SET n.`histology_cosmic` = nodeRecord.`HISTOLOGY_COSMIC`
SET n.`hist_subtype1_cosmic` = nodeRecord.`HIST_SUBTYPE1_COSMIC`
SET n.`hist_subtype3_cosmic` = nodeRecord.`HIST_SUBTYPE2_COSMIC`
SET n.`his_subtype3_cosmic` = nodeRecord.`HIST_SUBTYPE3_COSMIC`
SET n.`nci_code` = nodeRecord.`NCI_CODE`
SET n.`EFO` = nodeRecord.`EFO`;
',
{batchSize:1000, iterateList:true, parallel:true});

// GeneMutationCollection
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/cancer_gene_census.csv", { header:true}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT nodeRecord.`Gene Symbol` IS NULL
MERGE (n: `CosmicGeneMutationCollection` { `gene_symbol`: nodeRecord.`Gene Symbol` });
',
{batchSize:100, iterateList:true, parallel:true});

// CosmicStructuralMutation
CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicStructExport.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE  NOT toInteger(trim(nodeRecord.`MUTATION_ID`)) IS NULL
MERGE (n: `CosmicStructuralMutation` { `mutation_id`: toInteger(trim(nodeRecord.`MUTATION_ID`)) })
SET n.`sample_name` = nodeRecord.`Sample name`
SET n.`sample_id` = toInteger(trim(nodeRecord.`ID_SAMPLE`))
SET n.`tumor_id` = toInteger(trim(nodeRecord.`ID_TUMOUR`))
SET n.`mutation_type` = nodeRecord.`Mutation Type`
SET n.`GRCh` = toInteger(trim(nodeRecord.`GRCh`))
SET n.`description` = nodeRecord.`description`
SET n.`pub_id` = nodeRecord.`PUBMED_PMID`;
',
{batchSize:4000, iterateList:true, parallel:true});


// CosmicSampleMutationCollection

CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicSample.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`sample_id`)) IS NULL
MERGE (n: `CosmicSampleMutationCollection` { `sample_id`: toInteger(trim(nodeRecord.`sample_id`)) })
SET n.`sample_name` = nodeRecord.`sample_name`;
',
{batchSize:4000, iterateList:true, parallel:true});


// CosmicResistanceMutation

CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/CosmicResistanceMutations.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`MUTATION_ID`)) IS NULL
MERGE (n: `CosmicResistanceMutation` { `identifier`: toInteger(line_no) })
SET n.`mutation_id` = toInteger(nodeRecord.`MUTATION_ID`)
SET n.`sample_name` = nodeRecord.`Sample Name`
SET n.`sample_id` = toInteger(trim(nodeRecord.`Sample ID`))
SET n.`gene_symbol` = nodeRecord.`Gene Name`
SET n.`transcript` = nodeRecord.`Transcript`
SET n.`census_gene` = nodeRecord.`Census Gene`
SET n.`drug_name` = nodeRecord.`Drug Name`
SET n.`genomic_mutation_id` = nodeRecord.`GENOMIC_MUTATION_ID`
SET n.`legacy_mutation_id` = nodeRecord.`LEGACY_MUTATION_ID`
SET n.`aa_mutation` = nodeRecord.`AA Mutation`
SET n.`cds_mutation` = nodeRecord.`CDS Mutation`
SET n.`primary_tissue` = nodeRecord.`Primary Tissue`
SET n.`pub_id` = toInteger(trim(nodeRecord.`Pubmed Id`))
SET n.`cgp_study` = nodeRecord.`CGP Study`
SET n.`somatic_status` = nodeRecord.`Somatic Status`
SET n.`sample_type` = nodeRecord.`Sample Type`
SET n.`zygosity` = nodeRecord.`Zygosity`
SET n.`genome_coordinates_grch38` = nodeRecord.`Genome Coordinates (GRCh38)`
SET n.`tier` = toLower(trim(nodeRecord.`Tier`)) IN ['1','true','yes']
SET n.`HGVSP` = nodeRecord.`HGVSP`
SET n.`HGVSC` = nodeRecord.`HGVSC`
SET n.`HGVSG` = nodeRecord.`HGVSG`;
',
{batchSize:4000, iterateList:true, parallel:true});

// CosmicHallmark

CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/COSMIC_rel97/Cancer_Gene_Census_Hallmarks_Of_Cancer.tsv", { header:true,  sep:"TAB"}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE NOT toInteger(trim(nodeRecord.`GENE_NAME`)) IS NULL
MERGE (n: `CosmicGeneHallmark` { `hallmark_id`: toInteger(lineNo) })
SET n.`gene_symbol` = nodeRecord.`GENE_NAME`
SET n.`cell_type` = nodeRecord.`CELL_TYPE`
SET n.`pub_id` = toInteger(trim(nodeRecord.`PUBMED_PMID`))
SET n.`hallmark` = nodeRecord.`HALLMARK`
SET n.`impact` = nodeRecord.`IMPACT`
SET n.`description` = nodeRecord.`DESCRIPTION`
',
{batchSize:4000, iterateList:true, parallel:true});

// SynMIC

CALL apoc.periodic.iterate('
CALL apoc.load.csv("/Volumes/SSD870/SpecializedCancerDatasets/SynMICdb/", { header:true}
)
YIELD lineNo, map AS nodeRecord RETURN nodeRecord, lineNo
','
WHERE  NOT toInteger(trim(nodeRecord.`"SynMIC_ID"`)) IS NULL

MERGE (n: `SynMIC` { `synmic_id`: toInteger(lineNo) })
SET n.`gene_symbol` = nodeRecord.`Gene Name`
SET n.`transcript_id` = nodeRecord.`Transcript ID`
SET n.`mutation_id` = nodeRecord.`Mutation ID`
SET n.`mutation_nt` = nodeRecord.`Mutation nt`
SET n.`Mutation aa` = nodeRecord.`Mutation aa`
SET n.`mutation_genome_position` = nodeRecord.`Mutation Genome Position`
SET n.`chromosome` = nodeRecord.`Chromosome`
SET n.`start` = nodeRecord.`Start`
SET n.`end` = nodeRecord.`End`
SET n.`strand` = nodeRecord.`Strand`
SET n.`signature-normalized_frequency` = toFloat(trim(nodeRecord.`Signature-normalized Frequency`))
SET n.`average_mutation_load` = toInteger(trim(nodeRecord.`Average Mutation Load`))
SET n.`alternative_events` = nodeRecord.`Alternative Events`
SET n.`SNP` = nodeRecord.`SNP`
SET n.`conservation` = nodeRecord.`Conservation`
SET n.`structure_change_score_(remuRNA)` = nodeRecord.`Structure Change Score (remuRNA)`
SET n.`structure_change_score_((RNAsnp)` = nodeRecord.`Structure Change Significance (RNAsnp)`
SET n.`synmicdb_score` = nodeRecord.`SynMICdb Score`
SET n.`sample_name` = nodeRecord.`Sample ID`
SET n.`organ_sytem` = nodeRecord.`Organ System`
SET n.`site` = nodeRecord.`Site`
SET n.`histology` = nodeRecord.`Histology`
SET n.`mutation_load_sample` = toInteger(trim(nodeRecord.`Mutation Load Sample`))
SET n.`position_in_cds` = toFloat(trim(nodeRecord.`Position in CDS`))
SET n.`gcg_gene` = trim(nodeRecord.`CGC Gene`))
SET n.`exon_type` = nodeRecord.`Exon Type`
SET n.`distance_to_closest_exon_boundary` = nodeRecord.`Distance to Closest Exon Boundary`
SET n.`ese_gain_(RegRNA 2.0)` = nodeRecord.`ESE Gain (RegRNA 2.0)`
SET n.`ese_loss_(RegRNA 2.0)` = nodeRecord.`ESE Loss (RegRNA 2.0)`
SET n.`ess_gain_(RegRNA 2.0)` = nodeRecord.`ESS Gain (RegRNA 2.0)`
SET n.`ess_loss_(RegRNA 2.0)` = nodeRecord.`ESS Loss (RegRNA 2.0)`
SET n.`ese_gain_(SpliceAidF)` = nodeRecord.`ESE Gain (SpliceAidF)`
SET n.`ese_loss_(SpliceAidF)` = nodeRecord.`ESE Loss (SpliceAidF)`
SET n.`ess_gain_(SpliceAidF)` = nodeRecord.`ESS Gain (SpliceAidF)`
SET n.`ess_loss_(SpliceAidF)` = nodeRecord.`ESS Loss (SpliceAidF)`
SET n.`ese_&&ess_gain_(SpliceAidF)` = nodeRecord.`ESE & ESS Gain (SpliceAidF)`
SET n.`ese_&_ess_loss_(SpliceAidF)` = nodeRecord.`ESE & ESS Loss (SpliceAidF)`
SET n.`any_ese/ess_change` = nodeRecord.`Any ESE/ESS Change`;
',
{batchSize:4000, iterateList:true, parallel:true});

CREATE CONSTRAINT `imp_uniq_AltSpliceCancer_id` IF NOT EXISTS
FOR (n: `AltSpliceCancer`)
REQUIRE (n.`id`) IS UNIQUE;

UNWIND $nodeRecords AS nodeRecord
WITH *
WHERE NOT nodeRecord.`id` IN $idsToSkip AND NOT nodeRecord.`id` IS NULL
MERGE (n: `AltSpliceCancer` { `id`: nodeRecord.`id` })
SET n.`has_oncoprint` = nodeRecord.`has_oncoprint`
SET n.`event_id` = nodeRecord.`event_id`
SET n.`as_model_id` = nodeRecord.`as_model_id`
SET n.`cancer_name` = nodeRecord.`cancer_name`
SET n.`tcga_project_id` = nodeRecord.`tcga_project_id`
SET n.`gene_symbol` = nodeRecord.`gene_name`
SET n.`hgnc_id` = toInteger(trim(nodeRecord.`hgnc_id`))
SET n.`ensembl_id` = nodeRecord.`ensembl_id`
SET n.`chr` = nodeRecord.`chr`
SET n.`strand` = nodeRecord.`strand`
SET n.`canonical_transcript_id` = nodeRecord.`canonical_transcript_id`
SET n.`ct_ensembl_id` = nodeRecord.`ct_ensembl_id`
SET n.`ct_refSeq_id` = nodeRecord.`ct_refSeq_id`
SET n.`canonical_transcript_description` = nodeRecord.`canonical_transcript_description`
SET n.`splice_variant_id` = nodeRecord.`splice_variant_id`
SET n.`sv_ensembl_id` = nodeRecord.`sv_ensembl_id`
SET n.`sv_refSeq_id` = nodeRecord.`sv_refSeq_id`
SET n.`splice_variant_description` = nodeRecord.`splice_variant_description`
SET n.`as_type` = nodeRecord.`as_type`
SET n.`related_exons` = nodeRecord.`related_exons`
SET n.`exon_ensembl_id` = nodeRecord.`exon_ensembl_id`
SET n.`event_coordinates` = nodeRecord.`event_coordinates`
SET n.`alt_coordinates` = nodeRecord.`alt_coordinates`
SET n.`splice_in_isoforms` = nodeRecord.`splice_in_isoforms`
SET n.`splice_out_isoforms` = nodeRecord.`splice_out_isoforms`
SET n.`orf_annotation` = nodeRecord.`orf_annotation`
SET n.`primer_f` = nodeRecord.`primer_f`
SET n.`primer_r` = nodeRecord.`primer_r`
SET n.`cell_line` = nodeRecord.`cell_line`
SET n.`primary_site` = nodeRecord.`primary_site`
SET n.`samples` = nodeRecord.`samples`
SET n.`methods` = nodeRecord.`methods`
SET n.`external_intervention` = nodeRecord.`external_intervention`
SET n.`regulatory_mechanism` = nodeRecord.`regulatory_mechanism`
SET n.`regulatory_gene` = nodeRecord.`regulatory_gene`
SET n.`biological_function` = nodeRecord.`biological_function`
SET n.`functional_description` = nodeRecord.`functional_description`
SET n.`year` = toInteger(trim(nodeRecord.`year`))
SET n.`pubmed_id` = toInteger(trim(nodeRecord.`pubmed_id`))
SET n.`journal` = nodeRecord.`journal`
SET n.`title` = nodeRecord.`title`;

CREATE CONSTRAINT `imp_uniq_HGNC_hgnc_id` IF NOT EXISTS
FOR (n: `HGNC`)
REQUIRE (n.`hgnc_id`) IS UNIQUE;

UNWIND $nodeRecords AS nodeRecord
WITH *
WHERE NOT nodeRecord.`hgnc_id` IN $idsToSkip AND NOT toInteger(trim(nodeRecord.`hgnc_id`)) IS NULL
MERGE (n: `HGNC` { `hgnc_id`: toInteger(trim(nodeRecord.`hgnc_id`)) })
SET n.`gene_symbol` = nodeRecord.`symbol`
SET n.`name` = nodeRecord.`name`
SET n.`locus_group` = nodeRecord.`locus_group`
SET n.`locus_type` = nodeRecord.`locus_type`
SET n.`status` = nodeRecord.`status`
SET n.`location` = nodeRecord.`location`
SET n.`location_sortable` = nodeRecord.`location_sortable`
SET n.`alias_symbol` = nodeRecord.`alias_symbol`
SET n.`alias_name` = nodeRecord.`alias_name`
SET n.`prev_symbol` = nodeRecord.`prev_symbol`
SET n.`prev_name` = nodeRecord.`prev_name`
SET n.`gene_group` = nodeRecord.`gene_group`
SET n.`gene_group_id` = nodeRecord.`gene_group_id`
SET n.`date_approved_reserved` = datetime(nodeRecord.`date_approved_reserved`)
SET n.`date_symbol_changed` = datetime(nodeRecord.`date_symbol_changed`)
SET n.`date_name_changed` = datetime(nodeRecord.`date_name_changed`)
SET n.`date_modified` = datetime(nodeRecord.`date_modified`)
SET n.`entrez_id` = toInteger(trim(nodeRecord.`entrez_id`))
SET n.`ensembl_gene_id` = nodeRecord.`ensembl_gene_id`
SET n.`vega_id` = nodeRecord.`vega_id`
SET n.`ucsc_id` = nodeRecord.`ucsc_id`
SET n.`ena` = nodeRecord.`ena`
SET n.`refseq_accession` = nodeRecord.`refseq_accession`
SET n.`ccds_id` = nodeRecord.`ccds_id`
SET n.`uniprot_ids` = nodeRecord.`uniprot_ids`
SET n.`pubmed_id` = nodeRecord.`pubmed_id`
SET n.`mgd_id` = nodeRecord.`mgd_id`
SET n.`rgd_id` = nodeRecord.`rgd_id`
SET n.`lsdb` = nodeRecord.`lsdb`
SET n.`cosmic` = nodeRecord.`cosmic`
SET n.`omim_id` = toInteger(trim(nodeRecord.`omim_id`))
SET n.`mirbase` = nodeRecord.`mirbase`
SET n.`homeodb` = nodeRecord.`homeodb`
SET n.`snornabase` = nodeRecord.`snornabase`
SET n.`bioparadigms_slc` = nodeRecord.`bioparadigms_slc`
SET n.`orphanet` = toInteger(trim(nodeRecord.`orphanet`))
SET n.`pseudogene.org` = nodeRecord.`pseudogene.org`
SET n.`horde_id` = nodeRecord.`horde_id`
SET n.`merops` = nodeRecord.`merops`
SET n.`imgt` = nodeRecord.`imgt`
SET n.`iuphar` = nodeRecord.`iuphar`
SET n.`kznf_gene_catalog` = nodeRecord.`kznf_gene_catalog`
SET n.`mamit-trnadb` = nodeRecord.`mamit-trnadb`
SET n.`cd` = nodeRecord.`cd`
SET n.`lncrnadb` = nodeRecord.`lncrnadb`
SET n.`enzyme_id` = nodeRecord.`enzyme_id`
SET n.`intermediate_filament_db` = nodeRecord.`intermediate_filament_db`
SET n.`rna_central_ids` = nodeRecord.`rna_central_ids`
SET n.`lncipedia` = nodeRecord.`lncipedia`
SET n.`gtrnadb` = nodeRecord.`gtrnadb`
SET n.`agr` = toInteger(trim(nodeRecord.`agr`))
SET n.`mane_select` = nodeRecord.`mane_select`
SET n.`gencc` = toInteger(trim(nodeRecord.`gencc`));

CREATE CONSTRAINT `imp_uniq_CosmicBreakPointMutation_ID_SAMPLE` IF NOT EXISTS
FOR (n: `CosmicBreakPointMutation`)
REQUIRE (n.`ID_SAMPLE`) IS UNIQUE;

UNWIND $nodeRecords AS nodeRecord
WITH *
WHERE NOT nodeRecord.`ID_SAMPLE` IN $idsToSkip AND NOT toInteger(trim(nodeRecord.`ID_SAMPLE`)) IS NULL
MERGE (n: `CosmicBreakPointMutation` { `ID_SAMPLE`: toInteger(trim(nodeRecord.`ID_SAMPLE`)) })
SET n.`Sample name` = nodeRecord.`Sample name`
SET n.`ID_TUMOUR` = toInteger(trim(nodeRecord.`ID_TUMOUR`))
SET n.`Mutation Type` = nodeRecord.`Mutation Type`
SET n.`Mutation ID` = toInteger(trim(nodeRecord.`Mutation ID`))
SET n.`Breakpoint Order` = nodeRecord.`Breakpoint Order`
SET n.`GRCh` = toInteger(trim(nodeRecord.`GRCh`))
SET n.`Chrom From` = toInteger(trim(nodeRecord.`Chrom From`))
SET n.`Location From min` = toInteger(trim(nodeRecord.`Location From min`))
SET n.`Location From max` = toInteger(trim(nodeRecord.`Location From max`))
SET n.`Strand From` = nodeRecord.`Strand From`
SET n.`Chrom To` = toInteger(trim(nodeRecord.`Chrom To`))
SET n.`Location To min` = toInteger(trim(nodeRecord.`Location To min`))
SET n.`Location To max` = toInteger(trim(nodeRecord.`Location To max`))
SET n.`Strand To` = nodeRecord.`Strand To`
SET n.`Non-templated ins seq` = nodeRecord.`Non-templated ins seq`
SET n.`Pubmed_PMID` = nodeRecord.`Pubmed_PMID`;

UNWIND $relRecords AS relRecord
MATCH (source: `Patient` { `id_individual`: toInteger(trim(relRecord.`id_individual`)) })
MATCH (target: `Tumor` { `id_tumour`: toInteger(trim(relRecord.`id_tumour`)) })
MERGE (source)-[r: `HAS_TUMOR`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `Tumor` { `id_tumour`: toInteger(trim(relRecord.`id_tumour`)) })
MATCH (target: `CosmicSample` { `sample_id`: toInteger(trim(relRecord.`sample_id`)) })
MERGE (source)-[r: `HAS_SAMPLE`]->(target);


UNWIND $relRecords AS relRecord
MATCH (source: `CosmicSample` { `sample_id`: toInteger(trim(relRecord.`cosmic_phenotype_id`)) })
MATCH (target: `CosmicSampleClassification` { `COSMIC_PHENOTYPE_ID`: relRecord.`cosmic_phenotype_id` })
MERGE (source)-[r: `HAS_CLASSIFICATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGene` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `CosmicGeneMutationCollection` { `Gene Symbol`: relRecord.`Gene Symbol` })
MERGE (source)-[r: `HAS_GENE_MUTATION_COLLECTION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGeneMutationCollection` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `CosmicMutation` { `MUTATION_ID`: toInteger(trim(relRecord.`Gene Symbol`)) })
MERGE (source)-[r: `HAS_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicSample` { `sample_id`: toInteger(trim(relRecord.`sample_id`)) })
MATCH (target: `CosmicSampleMutationCollection` { `sample_id`: toInteger(trim(relRecord.`sample_id`)) })
MERGE (source)-[r: `HAS_SAMPLE_MUTATION_COLLECTION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicSampleMutationCollection` { `sample_id`: toInteger(trim(relRecord.`sample_id`)) })
MATCH (target: `CosmicStucturalMutation` { `MUTATION_ID`: toInteger(trim(relRecord.`sample_id`)) })
MERGE (source)-[r: `HAS_STRUCTURA_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicSampleMutationCollection` { `sample_id`: toInteger(trim(relRecord.`MUTATION_ID`)) })
MATCH (target: `CosmicMutation` { `MUTATION_ID`: toInteger(trim(relRecord.`MUTATION_ID`)) })
MERGE (source)-[r: `HAS_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGene` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `CosmicGeneHallmark` { `HALLMARK_ID`: toInteger(trim(relRecord.`Gene Symbol`)) })
MERGE (source)-[r: `HAS_COSMIC_HALLMARK`]->(target);
UNWIND $relRecords AS relRecord
MATCH (source: `CosmicSampleMutationCollection` { `sample_id`: toInteger(trim(relRecord.`sample_id`)) })
MATCH (target: `CosmicResistanceMutation` { `MUTATION_ID`: toInteger(trim(relRecord.`sample_id`)) })
MERGE (source)-[r: `HAS_RESISTANCE_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGeneMutationCollection` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `CosmicResistanceMutation` { `MUTATION_ID`: toInteger(trim(relRecord.`Gene Symbol`)) })
MERGE (source)-[r: `HAS_RESISTANCE_MUTATION`]->(target);
UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGeneMutationCollection` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `CosmicStucturalMutation` { `MUTATION_ID`: toInteger(trim(relRecord.`Gene Symbol`)) })
MERGE (source)-[r: `HAS_STRUCTURAL_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGeneMutationCollection` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `SynMIC` { `SynMIC_ID`: toInteger(trim(relRecord.`Gene Symbol`)) })
MERGE (source)-[r: `HAS_SYNONYMOUS_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicSampleMutationCollection` { `sample_id`: toInteger(trim(relRecord.`sample_name`)) })
MATCH (target: `SynMIC` { `SynMIC_ID`: toInteger(trim(relRecord.`sample_name`)) })
MERGE (source)-[r: `HAS_SYNONYMOUS_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGene` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `AltSpliceCancer` { `id`: relRecord.`Gene Symbol` })
MERGE (source)-[r: `HAS_ALTERNATE_SPLICING`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `AltSpliceCancer` { `id`: relRecord.`hgnc_id` })
MATCH (target: `HGNC` { `hgnc_id`: toInteger(trim(relRecord.`hgnc_id`)) })
MERGE (source)-[r: `HAS_HGNC`]->(target);


UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGene` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `HGNC` { `hgnc_id`: toInteger(trim(relRecord.`Gene Symbol`)) })
MERGE (source)-[r: `HAS_HGNC`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicSampleMutationCollection` { `sample_id`: toInteger(trim(relRecord.`sample_id`)) })
MATCH (target: `CosmicBreakPointMutation` { `ID_SAMPLE`: toInteger(trim(relRecord.`sample_id`)) })
MERGE (source)-[r: `HAS_BREAKPOINT_MUTATION`]->(target);

UNWIND $relRecords AS relRecord
MATCH (source: `CosmicGeneMutationCollection` { `Gene Symbol`: relRecord.`Gene Symbol` })
MATCH (target: `CosmicBreakPointMutation` { `ID_SAMPLE`: toInteger(trim(relRecord.`Gene Symbol`)) })
MERGE (source)-[r: `HAS_BREAKPOINT_MUTATION`]->(target);


























































